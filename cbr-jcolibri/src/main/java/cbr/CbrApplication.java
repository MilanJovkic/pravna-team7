package cbr;

import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import connector.PostgresConnector;
import es.ucm.fdi.gaia.jcolibri.casebase.LinealCaseBase;
import es.ucm.fdi.gaia.jcolibri.cbraplications.StandardCBRApplication;
import es.ucm.fdi.gaia.jcolibri.cbrcore.Attribute;
import es.ucm.fdi.gaia.jcolibri.cbrcore.CBRCaseBase;
import es.ucm.fdi.gaia.jcolibri.cbrcore.CBRQuery;
import es.ucm.fdi.gaia.jcolibri.cbrcore.Connector;
import es.ucm.fdi.gaia.jcolibri.exception.ExecutionException;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.NNConfig;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.NNScoringMethod;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.similarity.global.Average;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.similarity.local.Equal;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.RetrievalResult;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.selection.SelectCases;
import model.CaseDescription;
import similarity.TabularSimilarity;

public class CbrApplication implements StandardCBRApplication {

    private Connector connector;
    private CBRCaseBase caseBase;
    private NNConfig simConfig;

    public void configure() throws ExecutionException {
        connector = new PostgresConnector();
        caseBase = new LinealCaseBase();

        simConfig = new NNConfig();
        simConfig.setDescriptionSimFunction(new Average());

        TabularSimilarity injurySim = new TabularSimilarity(
                Arrays.asList(new String[] {"teska tjelesna povreda", "laka tjelesna povreda"})
        );
        injurySim.setSimilarity("teska tjelesna povreda", "laka tjelesna povreda", 0.5);

        TabularSimilarity fightConsequenceSim = new TabularSimilarity(
                Arrays.asList(new String[] {"none", "death_or_serious_injury"})
        );
        fightConsequenceSim.setSimilarity("none", "death_or_serious_injury", 0.5);

        simConfig.addMapping(new Attribute("injuryType", CaseDescription.class), injurySim);
        simConfig.addMapping(new Attribute("location", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("weapon", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("weaponUsed", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("severeConsequence", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("deathResult", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("negligence", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("provocation", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("fightParticipation", CaseDescription.class), new Equal());
        simConfig.addMapping(new Attribute("fightConsequence", CaseDescription.class), fightConsequenceSim);
        simConfig.addMapping(new Attribute("leftWithoutHelp", CaseDescription.class), new Equal());
    }

    public void cycle(CBRQuery query) throws ExecutionException {
        Collection<RetrievalResult> eval = runQuery(query, 5);
        System.out.println("Retrieved cases:");
        for (RetrievalResult nse : eval) {
            System.out.println(nse.get_case().getDescription() + " -> " + nse.getEval());
        }
    }

    public Collection<RetrievalResult> runQuery(CBRQuery query, int topK) throws ExecutionException {
        Collection<RetrievalResult> eval = NNScoringMethod.evaluateSimilarity(caseBase.getCases(), query, simConfig);
        return SelectCases.selectTopKRR(eval, topK);
    }

    public void postCycle() throws ExecutionException {
    }

    public CBRCaseBase preCycle() throws ExecutionException {
        caseBase.init(connector);
        return caseBase;
    }

    public static void main(String[] args) {
        CbrApplication app = new CbrApplication();
        try {
            setUtf8Output();
            app.configure();
            app.preCycle();

            Map<String, String> params = parseArgs(args);
            boolean jsonOutput = params.containsKey("__json");
            params.remove("__json");
            int topK = parseTopK(params, 5);

            CBRQuery query = new CBRQuery();
            CaseDescription queryCase = buildQueryCase(params);
            query.setDescription(queryCase);

            Collection<RetrievalResult> results = app.runQuery(query, topK);
            if (jsonOutput) {
                System.out.println(toJson(results));
            } else {
                System.out.println("Retrieved cases:");
                for (RetrievalResult nse : results) {
                    System.out.println(nse.get_case().getDescription() + " -> " + nse.getEval());
                }
            }

            app.postCycle();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void setUtf8Output() throws UnsupportedEncodingException {
        System.setOut(new PrintStream(System.out, true, "UTF-8"));
        System.setErr(new PrintStream(System.err, true, "UTF-8"));
    }

    private static Map<String, String> parseArgs(String[] args) {
        Map<String, String> params = new HashMap<>();
        for (String arg : args) {
            if ("--json".equalsIgnoreCase(arg)) {
                params.put("__json", "true");
                continue;
            }
            if (!arg.contains("=")) {
                continue;
            }
            String[] parts = arg.split("=", 2);
            if (parts.length == 2) {
                params.put(parts[0].trim(), parts[1].trim());
            }
        }
        return params;
    }

    private static int parseTopK(Map<String, String> params, int fallback) {
        String value = params.remove("top_k");
        if (value == null || value.isEmpty()) {
            value = params.remove("topK");
        }
        if (value == null || value.isEmpty()) {
            return fallback;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }

    private static CaseDescription buildQueryCase(Map<String, String> params) {
        CaseDescription queryCase = new CaseDescription();
        String injuryType = first(params, "injury_type", "injuryType");
        String location = first(params, "location");
        String weapon = first(params, "weapon");
        String weaponUsed = first(params, "weapon_used", "weaponUsed");
        String severeConsequence = first(params, "severe_consequence", "severeConsequence");
        String deathResult = first(params, "death_result", "deathResult");
        String negligence = first(params, "negligence");
        String provocation = first(params, "provocation");
        String fightParticipation = first(params, "fight_participation", "fightParticipation");
        String fightConsequence = first(params, "fight_consequence", "fightConsequence");
        String leftWithoutHelp = first(params, "left_without_help", "leftWithoutHelp");

        if (injuryType != null) {
            queryCase.setInjuryType(injuryType);
        }
        if (location != null) {
            queryCase.setLocation(location);
        }
        if (weapon != null) {
            queryCase.setWeapon(weapon);
        }
        if (weaponUsed != null) {
            queryCase.setWeaponUsed(weaponUsed);
        }
        if (severeConsequence != null) {
            queryCase.setSevereConsequence(severeConsequence);
        }
        if (deathResult != null) {
            queryCase.setDeathResult(deathResult);
        }
        if (negligence != null) {
            queryCase.setNegligence(negligence);
        }
        if (provocation != null) {
            queryCase.setProvocation(provocation);
        }
        if (fightParticipation != null) {
            queryCase.setFightParticipation(fightParticipation);
        }
        if (fightConsequence != null) {
            queryCase.setFightConsequence(fightConsequence);
        }
        if (leftWithoutHelp != null) {
            queryCase.setLeftWithoutHelp(leftWithoutHelp);
        }

        if (params.isEmpty()) {
            queryCase.setInjuryType("teska tjelesna povreda");
            queryCase.setLocation("Podgorica");
            queryCase.setWeapon("metalni kljuc");
            queryCase.setWeaponUsed("true");
            queryCase.setSevereConsequence("true");
            queryCase.setDeathResult("false");
            queryCase.setNegligence("false");
            queryCase.setProvocation("false");
            queryCase.setFightParticipation("false");
            queryCase.setFightConsequence("none");
            queryCase.setLeftWithoutHelp("false");
        }

        return queryCase;
    }

    private static String first(Map<String, String> params, String... keys) {
        for (String key : keys) {
            String value = params.get(key);
            if (value != null && !value.isEmpty()) {
                return value;
            }
        }
        return null;
    }

    private static String toJson(Collection<RetrievalResult> results) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\"matches\":[");
        boolean first = true;
        for (RetrievalResult nse : results) {
            CaseDescription desc = (CaseDescription) nse.get_case().getDescription();
            if (!first) {
                sb.append(",");
            }
            first = false;
            sb.append("{\"case_number\":\"")
                .append(jsonEscape(desc.getCaseNumber()))
                .append("\",\"similarity\":")
                .append(nse.getEval())
                .append(",\"outcome\":\"")
                .append(jsonEscape(desc.getOutcome()))
                .append("\"}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private static String jsonEscape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
