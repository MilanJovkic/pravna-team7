package cbr;

import java.util.Arrays;
import java.util.Collection;

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
        Collection<RetrievalResult> eval = NNScoringMethod.evaluateSimilarity(caseBase.getCases(), query, simConfig);
        eval = SelectCases.selectTopKRR(eval, 5);
        System.out.println("Retrieved cases:");
        for (RetrievalResult nse : eval) {
            System.out.println(nse.get_case().getDescription() + " -> " + nse.getEval());
        }
    }

    public void postCycle() throws ExecutionException {
    }

    public CBRCaseBase preCycle() throws ExecutionException {
        caseBase.init(connector);
        return caseBase;
    }

    public static void main(String[] args) {
        StandardCBRApplication app = new CbrApplication();
        try {
            app.configure();
            app.preCycle();

            CBRQuery query = new CBRQuery();
            CaseDescription queryCase = new CaseDescription();
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
            query.setDescription(queryCase);

            app.cycle(query);
            app.postCycle();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
