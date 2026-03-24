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

        private static final String JDBC_URL = String.format(
            "jdbc:postgresql://%s:%s/%s",
            env("DB_HOST", "127.0.0.1"),
            env("DB_PORT", "5432"),
            env("DB_NAME", "pravna_cbr")
        );
        private static final String JDBC_USER = env("DB_USER", "pravna_user");
        private static final String JDBC_PASSWORD = env("DB_PASSWORD", "pravna_pass");

    @Override
    public Collection<CBRCase> retrieveAllCases() {
        LinkedList<CBRCase> cases = new LinkedList<CBRCase>();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM cases ORDER BY id DESC");

            while (rs.next()) {
                CBRCase cbrCase = new CBRCase();
                CaseDescription caseDescription = new CaseDescription();

                caseDescription.setId(rs.getInt("id"));
                caseDescription.setCaseNumber(rs.getString("case_number"));
                caseDescription.setInjuryType(rs.getString("injury_type"));
                caseDescription.setLocation(rs.getString("location"));
                caseDescription.setWeapon(rs.getString("weapon"));
                caseDescription.setWeaponUsed(boolToString((Boolean) rs.getObject("weapon_used")));
                caseDescription.setSevereConsequence(boolToString((Boolean) rs.getObject("severe_consequence")));
                caseDescription.setDeathResult(boolToString((Boolean) rs.getObject("death_result")));
                caseDescription.setNegligence(boolToString((Boolean) rs.getObject("negligence")));
                caseDescription.setProvocation(boolToString((Boolean) rs.getObject("provocation")));
                caseDescription.setFightParticipation(boolToString((Boolean) rs.getObject("fight_participation")));
                caseDescription.setFightConsequence(rs.getString("fight_consequence"));
                caseDescription.setLeftWithoutHelp(boolToString((Boolean) rs.getObject("left_without_help")));
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

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        if (value == null || value.isEmpty()) {
            return fallback;
        }
        return value;
    }

    private static String boolToString(Boolean value) {
        if (value == null) {
            return "unknown";
        }
        return value.booleanValue() ? "true" : "false";
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
