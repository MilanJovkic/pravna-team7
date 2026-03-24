package connector;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Collection;
import java.util.LinkedList;

import es.ucm.fdi.gaia.jcolibri.cbrcore.CBRCase;
import es.ucm.fdi.gaia.jcolibri.cbrcore.CaseBaseFilter;
import es.ucm.fdi.gaia.jcolibri.cbrcore.Connector;
import es.ucm.fdi.gaia.jcolibri.exception.InitializingException;
import model.CaseDescription;

public class CsvConnector implements Connector {

    @Override
    public Collection<CBRCase> retrieveAllCases() {
        LinkedList<CBRCase> cases = new LinkedList<CBRCase>();

        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(getClass().getResourceAsStream("/presude.csv"))
            );
            if (br == null) {
                throw new Exception("Error opening file");
            }

            String line = "";
            while ((line = br.readLine()) != null) {
                if (line.startsWith("#") || (line.length() == 0)) {
                    continue;
                }
                String[] values = line.split(";");

                CBRCase cbrCase = new CBRCase();
                CaseDescription caseDescription = new CaseDescription();

                caseDescription.setId(Integer.parseInt(values[0]));
                caseDescription.setCaseNumber(values[1]);
                caseDescription.setInjuryType(values[2]);
                caseDescription.setLocation(values[3]);
                caseDescription.setWeapon(values[4]);
                caseDescription.setWeaponUsed(values[5]);
                caseDescription.setSevereConsequence(values[6]);
                caseDescription.setDeathResult(values[7]);
                caseDescription.setNegligence(values[8]);
                caseDescription.setProvocation(values[9]);
                caseDescription.setFightParticipation(values[10]);
                caseDescription.setFightConsequence(values[11]);
                caseDescription.setLeftWithoutHelp(values[12]);
                caseDescription.setOutcome(values[13]);

                cbrCase.setDescription(caseDescription);
                cases.add(cbrCase);
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cases;
    }

    @Override
    public Collection<CBRCase> retrieveSomeCases(CaseBaseFilter arg0) {
        return null;
    }

    @Override
    public void storeCases(Collection<CBRCase> arg0) {
    }

    @Override
    public void close() {
    }

    @Override
    public void deleteCases(Collection<CBRCase> arg0) {
    }

    @Override
    public void initFromXMLfile(URL arg0) throws InitializingException {
    }
}
