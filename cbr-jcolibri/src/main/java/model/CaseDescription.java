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
    private String previousConvictions;
    private String repeatOffender;
    private String confession;
    private String remorse;
    private String pleaAgreement;
    private String aggravatingCircumstances;
    private String mitigatingCircumstances;
    private String familyCircumstances;
    private String poorFinancialStatus;
    private String alcoholIntoxication;
    private String narcoticsInfluence;
    private String conditionalSentenceRequested;
    private String attemptedOffense;
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

    public String getPreviousConvictions() {
        return previousConvictions;
    }

    public void setPreviousConvictions(String previousConvictions) {
        this.previousConvictions = previousConvictions;
    }

    public String getRepeatOffender() {
        return repeatOffender;
    }

    public void setRepeatOffender(String repeatOffender) {
        this.repeatOffender = repeatOffender;
    }

    public String getConfession() {
        return confession;
    }

    public void setConfession(String confession) {
        this.confession = confession;
    }

    public String getRemorse() {
        return remorse;
    }

    public void setRemorse(String remorse) {
        this.remorse = remorse;
    }

    public String getPleaAgreement() {
        return pleaAgreement;
    }

    public void setPleaAgreement(String pleaAgreement) {
        this.pleaAgreement = pleaAgreement;
    }

    public String getAggravatingCircumstances() {
        return aggravatingCircumstances;
    }

    public void setAggravatingCircumstances(String aggravatingCircumstances) {
        this.aggravatingCircumstances = aggravatingCircumstances;
    }

    public String getMitigatingCircumstances() {
        return mitigatingCircumstances;
    }

    public void setMitigatingCircumstances(String mitigatingCircumstances) {
        this.mitigatingCircumstances = mitigatingCircumstances;
    }

    public String getFamilyCircumstances() {
        return familyCircumstances;
    }

    public void setFamilyCircumstances(String familyCircumstances) {
        this.familyCircumstances = familyCircumstances;
    }

    public String getPoorFinancialStatus() {
        return poorFinancialStatus;
    }

    public void setPoorFinancialStatus(String poorFinancialStatus) {
        this.poorFinancialStatus = poorFinancialStatus;
    }

    public String getAlcoholIntoxication() {
        return alcoholIntoxication;
    }

    public void setAlcoholIntoxication(String alcoholIntoxication) {
        this.alcoholIntoxication = alcoholIntoxication;
    }

    public String getNarcoticsInfluence() {
        return narcoticsInfluence;
    }

    public void setNarcoticsInfluence(String narcoticsInfluence) {
        this.narcoticsInfluence = narcoticsInfluence;
    }

    public String getConditionalSentenceRequested() {
        return conditionalSentenceRequested;
    }

    public void setConditionalSentenceRequested(String conditionalSentenceRequested) {
        this.conditionalSentenceRequested = conditionalSentenceRequested;
    }

    public String getAttemptedOffense() {
        return attemptedOffense;
    }

    public void setAttemptedOffense(String attemptedOffense) {
        this.attemptedOffense = attemptedOffense;
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
            + ", previousConvictions=" + previousConvictions + ", repeatOffender=" + repeatOffender
            + ", confession=" + confession + ", remorse=" + remorse + ", pleaAgreement=" + pleaAgreement
            + ", aggravatingCircumstances=" + aggravatingCircumstances
            + ", mitigatingCircumstances=" + mitigatingCircumstances
            + ", familyCircumstances=" + familyCircumstances
            + ", poorFinancialStatus=" + poorFinancialStatus
            + ", alcoholIntoxication=" + alcoholIntoxication
            + ", narcoticsInfluence=" + narcoticsInfluence
            + ", conditionalSentenceRequested=" + conditionalSentenceRequested
            + ", attemptedOffense=" + attemptedOffense
                + ", outcome=" + outcome + "]";
    }
}
