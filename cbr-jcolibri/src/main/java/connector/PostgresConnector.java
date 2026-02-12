package connector;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Collection;
import java.util.LinkedList;

import es.ucm.fdi.gaia.jcolibri.cbrcore.CBRCase;
import es.ucm.fdi.gaia.jcolibri.cbrcore.CaseBaseFilter;
import es.ucm.fdi.gaia.jcolibri.cbrcore.Connector;
import es.ucm.fdi.gaia.jcolibri.exception.InitializingException;
import model.CaseDescription;

public class PostgresConnector implements Connector {

    private static final String JDBC_URL = "jdbc:postgresql://localhost:5432/pravna_cbr";
    private static final String JDBC_USER = "pravna_user";
    private static final String JDBC_PASSWORD = "pravna_pass";

    @Override
    public Collection<CBRCase> retrieveAllCases() {
        LinkedList<CBRCase> cases = new LinkedList<CBRCase>();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM cases ORDER BY id");

            while (rs.next()) {
                CBRCase cbrCase = new CBRCase();
                CaseDescription caseDescription = new CaseDescription();

                caseDescription.setId(rs.getInt("id"));
                caseDescription.setCaseNumber(rs.getString("case_number"));
                caseDescription.setInjuryType(rs.getString("injury_type"));
                caseDescription.setLocation(rs.getString("location"));
                caseDescription.setWeapon(rs.getString("weapon"));
                caseDescription.setWeaponUsed(String.valueOf(rs.getBoolean("weapon_used")));
                caseDescription.setSevereConsequence(String.valueOf(rs.getBoolean("severe_consequence")));
                caseDescription.setDeathResult(String.valueOf(rs.getBoolean("death_result")));
                caseDescription.setNegligence(String.valueOf(rs.getBoolean("negligence")));
                caseDescription.setProvocation(String.valueOf(rs.getBoolean("provocation")));
                caseDescription.setFightParticipation(String.valueOf(rs.getBoolean("fight_participation")));
                caseDescription.setFightConsequence(rs.getString("fight_consequence"));
                caseDescription.setLeftWithoutHelp(String.valueOf(rs.getBoolean("left_without_help")));
                caseDescription.setOutcome(rs.getString("outcome"));

                cbrCase.setDescription(caseDescription);
                cases.add(cbrCase);
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.err.println("Error connecting to PostgreSQL: " + e.getMessage());
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
