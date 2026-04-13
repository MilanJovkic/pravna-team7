package cbr;

import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

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
import es.ucm.fdi.gaia.jcolibri.method.retrieve.NNretrieval.similarity.LocalSimilarityFunction;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.RetrievalResult;
import es.ucm.fdi.gaia.jcolibri.method.retrieve.selection.SelectCases;
import model.CaseDescription;
import similarity.SoftTextSimilarity;
import similarity.TabularSimilarity;
import similarity.UnknownAwareBooleanSimilarity;

public class CbrApplication implements StandardCBRApplication {

    private static final String UNKNOWN = "unknown";

    private Connector connector;
    private CBRCaseBase caseBase;
    private NNConfig simConfig;
    private List<FeatureSpec> featureSpecs;

    private static class FeatureSpec {
        private final String name;
        private final Attribute attribute;
        private final LocalSimilarityFunction function;
        private final double weight;
        private final Function<CaseDescription, String> extractor;

        private FeatureSpec(
                String name,
                Attribute attribute,
                LocalSimilarityFunction function,
                double weight,
                Function<CaseDescription, String> extractor) {
            this.name = name;
            this.attribute = attribute;
            this.function = function;
            this.weight = weight;
            this.extractor = extractor;
        }
    }

    public void configure() throws ExecutionException {
        connector = new PostgresConnector();
        caseBase = new LinealCaseBase();

        simConfig = new NNConfig();
        simConfig.setDescriptionSimFunction(new Average());
        featureSpecs = new ArrayList<FeatureSpec>();

        TabularSimilarity injurySim = new TabularSimilarity(
                Arrays.asList(new String[] {"teska tjelesna povreda", "laka tjelesna povreda", UNKNOWN})
        );
        injurySim.setSimilarity("teska tjelesna povreda", "laka tjelesna povreda", 0.35);

        TabularSimilarity fightConsequenceSim = new TabularSimilarity(
                Arrays.asList(new String[] {"none", "death_or_serious_injury", UNKNOWN})
        );
        fightConsequenceSim.setSimilarity("none", "death_or_serious_injury", 0.3);

        SoftTextSimilarity locationSim = new SoftTextSimilarity();
        locationSim.addSynonyms("podgorica", "podgorici", "podgorica centar");
        locationSim.addSynonyms("mostar", "mostaru", "grad mostar");
        locationSim.addSynonyms("danilovgrad", "danilovgradu");

        SoftTextSimilarity weaponSim = new SoftTextSimilarity();
        weaponSim.addSynonyms("noz", "nozem", "sjekivo", "secivo");
        weaponSim.addSynonyms("metalni kljuc", "kljuc", "metalni predmet");
        weaponSim.addSynonyms("staklena flasa", "flasa", "staklom");

        UnknownAwareBooleanSimilarity triBool = new UnknownAwareBooleanSimilarity();

        addFeature("injury_type", "injuryType", injurySim, 0.22, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeValue(c.getInjuryType());
            }
        });
        addFeature("location", "location", locationSim, 0.10, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeValue(c.getLocation());
            }
        });
        addFeature("weapon", "weapon", weaponSim, 0.08, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeValue(c.getWeapon());
            }
        });
        addFeature("weapon_used", "weaponUsed", triBool, 0.10, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getWeaponUsed());
            }
        });
        addFeature("severe_consequence", "severeConsequence", triBool, 0.12, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getSevereConsequence());
            }
        });
        addFeature("death_result", "deathResult", triBool, 0.10, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getDeathResult());
            }
        });
        addFeature("negligence", "negligence", triBool, 0.06, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getNegligence());
            }
        });
        addFeature("provocation", "provocation", triBool, 0.06, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getProvocation());
            }
        });
        addFeature("fight_participation", "fightParticipation", triBool, 0.06, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getFightParticipation());
            }
        });
        addFeature("fight_consequence", "fightConsequence", fightConsequenceSim, 0.05, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeValue(c.getFightConsequence());
            }
        });
        addFeature("left_without_help", "leftWithoutHelp", triBool, 0.05, new Function<CaseDescription, String>() {
            @Override
            public String apply(CaseDescription c) {
                return normalizeBoolean(c.getLeftWithoutHelp());
            }
        });
    }

    private void addFeature(
            String featureName,
            String attributeName,
            LocalSimilarityFunction function,
            double weight,
            Function<CaseDescription, String> extractor) {
        Attribute attribute = new Attribute(attributeName, CaseDescription.class);
        simConfig.addMapping(attribute, function);
        simConfig.setWeight(attribute, weight);
        featureSpecs.add(new FeatureSpec(featureName, attribute, function, weight, extractor));
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
                System.out.println(toJson(results, queryCase, app.featureSpecs));
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

    private static String toJson(Collection<RetrievalResult> results, CaseDescription queryCase, List<FeatureSpec> specs) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\"matches\":[");
        boolean first = true;
        for (RetrievalResult nse : results) {
            CaseDescription desc = (CaseDescription) nse.get_case().getDescription();
            Map<String, Double> contributions = computeContributions(queryCase, desc, specs);
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
                .append("\",\"feature_contributions\":")
                .append(toJsonObject(contributions))
                .append("}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private static Map<String, Double> computeContributions(
            CaseDescription queryCase,
            CaseDescription retrieved,
            List<FeatureSpec> specs) {
        if (specs == null || specs.isEmpty()) {
            return Collections.emptyMap();
        }

        Map<String, Double> weightedScores = new LinkedHashMap<String, Double>();
        double totalWeight = 0.0;

        for (FeatureSpec spec : specs) {
            String left = spec.extractor.apply(queryCase);
            String right = spec.extractor.apply(retrieved);
            double local = 0.0;
            try {
                local = spec.function.compute(left, right);
            } catch (Exception ex) {
                local = 0.0;
            }

            double weighted = local * spec.weight;
            weightedScores.put(spec.name, weighted);
            totalWeight += spec.weight;
        }

        if (totalWeight <= 0.0) {
            return weightedScores;
        }

        Map<String, Double> normalized = new LinkedHashMap<String, Double>();
        for (Map.Entry<String, Double> entry : weightedScores.entrySet()) {
            normalized.put(entry.getKey(), entry.getValue() / totalWeight);
        }
        return normalized;
    }

    private static String toJsonObject(Map<String, Double> map) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        boolean first = true;
        for (Map.Entry<String, Double> entry : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            sb.append("\"")
              .append(jsonEscape(entry.getKey()))
              .append("\":")
              .append(entry.getValue());
        }
        sb.append("}");
        return sb.toString();
    }

    private static String normalizeValue(String value) {
        if (value == null) {
            return UNKNOWN;
        }
        String normalized = value.trim().toLowerCase();
        if (normalized.isEmpty() || "null".equals(normalized)) {
            return UNKNOWN;
        }
        return normalized;
    }

    private static String normalizeBoolean(String value) {
        String normalized = normalizeValue(value);
        if ("true".equals(normalized) || "1".equals(normalized) || "yes".equals(normalized) || "da".equals(normalized)) {
            return "true";
        }
        if ("false".equals(normalized) || "0".equals(normalized) || "no".equals(normalized) || "ne".equals(normalized)) {
            return "false";
        }
        return UNKNOWN;
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
