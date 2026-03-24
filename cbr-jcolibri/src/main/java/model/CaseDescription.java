package model;

import es.ucm.fdi.gaia.jcolibri.cbrcore.Attribute;
import es.ucm.fdi.gaia.jcolibri.cbrcore.CaseComponent;

public class CaseDescription implements CaseComponent {

    private int id;
    private String caseNumber;
    private String injuryType;
    private String location;
    private String weapon;
    private String weaponUsed;
    private String severeConsequence;
    private String deathResult;
    private String negligence;
    private String provocation;
    private String fightParticipation;
    private String fightConsequence;
    private String leftWithoutHelp;
    private String outcome;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCaseNumber() {
        return caseNumber;
    }

    public void setCaseNumber(String caseNumber) {
        this.caseNumber = caseNumber;
    }

    public String getInjuryType() {
        return injuryType;
    }

    public void setInjuryType(String injuryType) {
        this.injuryType = injuryType;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWeapon() {
        return weapon;
    }

    public void setWeapon(String weapon) {
        this.weapon = weapon;
    }

    public String getWeaponUsed() {
        return weaponUsed;
    }

    public void setWeaponUsed(String weaponUsed) {
        this.weaponUsed = weaponUsed;
    }

    public String getSevereConsequence() {
        return severeConsequence;
    }

    public void setSevereConsequence(String severeConsequence) {
        this.severeConsequence = severeConsequence;
    }

    public String getDeathResult() {
        return deathResult;
    }

    public void setDeathResult(String deathResult) {
        this.deathResult = deathResult;
    }

    public String getNegligence() {
        return negligence;
    }

    public void setNegligence(String negligence) {
        this.negligence = negligence;
    }

    public String getProvocation() {
        return provocation;
    }

    public void setProvocation(String provocation) {
        this.provocation = provocation;
    }

    public String getFightParticipation() {
        return fightParticipation;
    }

    public void setFightParticipation(String fightParticipation) {
        this.fightParticipation = fightParticipation;
    }

    public String getFightConsequence() {
        return fightConsequence;
    }

    public void setFightConsequence(String fightConsequence) {
        this.fightConsequence = fightConsequence;
    }

    public String getLeftWithoutHelp() {
        return leftWithoutHelp;
    }

    public void setLeftWithoutHelp(String leftWithoutHelp) {
        this.leftWithoutHelp = leftWithoutHelp;
    }

    public String getOutcome() {
        return outcome;
    }

    public void setOutcome(String outcome) {
        this.outcome = outcome;
    }

    @Override
    public Attribute getIdAttribute() {
        return new Attribute("id", this.getClass());
    }

    @Override
    public String toString() {
        return "CaseDescription [id=" + id + ", caseNumber=" + caseNumber + ", injuryType=" + injuryType
                + ", location=" + location + ", weapon=" + weapon + ", weaponUsed=" + weaponUsed
                + ", severeConsequence=" + severeConsequence + ", deathResult=" + deathResult + ", negligence="
                + negligence + ", provocation=" + provocation + ", fightParticipation=" + fightParticipation
                + ", fightConsequence=" + fightConsequence + ", leftWithoutHelp=" + leftWithoutHelp
                + ", outcome=" + outcome + "]";
    }
}
