# Rules Traceability Matrix

Izvor: dr-device/dr-device/rulebase.clp
Format: pravilo -> clan/norma -> uslovi

| Pravilo | Clan/Norma | Uslovi |
|---|---|---|
| rule1 | crime_art143 | life_consequence_type = "smrt_nastupila"; guilt_form = "umisljaj_direktni" |
| rule2 | crime_art143 | life_consequence_type = "smrt_nastupila"; guilt_form = "umisljaj_eventualni" |
| rule3 | crime_art143 | DEPRECATED / inactive placeholder; slot retained for numbering stability |
| rule4 | crime_art144 | life_consequence_type = "smrt_nastupila"; execution_manner = "svirep" |
| rule5 | crime_art144 | life_consequence_type = "smrt_nastupila"; execution_manner = "podmukao" |
| rule6 | crime_art144 | life_consequence_type = "smrt_nastupila"; execution_manner = "bezobzirno_nasilnicko_ponasanje" |
| rule7 | crime_art144 | life_consequence_type = "smrt_nastupila"; danger_to_third_parties = "true" |
| rule8 | crime_art144 | life_consequence_type = "smrt_nastupila"; offender_motive = "koristoljublje" |
| rule9 | crime_art144 | life_consequence_type = "smrt_nastupila"; offender_motive = "izvrsenje_ili_prikrivanje_drugog_krivicnog_djela" |
| rule10 | crime_art144 | life_consequence_type = "smrt_nastupila"; offender_motive = "bezobzirna_osveta" |
| rule11 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_status = "sluzbeno_lice"; duty_connection = "u_vrsenju_sluzbene_duznosti" |
| rule12 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_status = "vojno_lice"; duty_connection = "u_vrsenju_sluzbene_duznosti" |
| rule13 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_status = "dijete" |
| rule14 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_status = "bremenita_zena" |
| rule15 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_status = "clan_porodice"; victim_previously_abused = "true" |
| rule16 | crime_art144 | life_consequence_type = "smrt_nastupila"; victim_count = "vise"; excludes na_mah / porodjajni_poremecaj / mercy-killing cases |
| rule17 | crime_art145 | life_consequence_type = "smrt_nastupila"; execution_manner = "na_mah" |
| rule18 | crime_art145 | life_consequence_type = "smrt_nastupila"; offender_psych_state = "jaka_razdrazenost_na_mah" |
| rule19 | crime_art146 | life_consequence_type = "smrt_nastupila"; offender_psych_state = "porodjajni_poremecaj"; victim_status = "majka" |
| rule20 | crime_art147 | DEPRECATED / inactive placeholder; slot retained for numbering stability |
| rule21 | crime_art147 | life_consequence_type = "smrt_nastupila"; victim_status = "punoljetno_lice"; victim_health_state = "tesko_zdravstveno_stanje"; victim_explicit_request = "da" |
| rule22 | crime_art148 | life_consequence_type = "smrt_nastupila"; guilt_form = "nehat" |
| rule23 | crime_art148 | DEPRECATED / inactive placeholder; slot retained for numbering stability |
| rule24 | crime_art149_1 | special_action_types = "navodjenje_na_samoubistvo"; suicide_outcome = "izvrseno" |
| rule25 | crime_art149_1 | special_action_types = "navodjenje_na_samoubistvo"; suicide_outcome = "pokusano" |
| rule26 | crime_art149_2 | special_action_types = "pomaganje_u_samoubistvu"; victim_status = "punoljetno_lice"; victim_health_state = "tesko_zdravstveno_stanje"; victim_explicit_request = "da"; suicide_outcome = "izvrseno" |
| rule27 | crime_art149_2 | special_action_types = "pomaganje_u_samoubistvu"; victim_status = "punoljetno_lice"; victim_health_state = "tesko_zdravstveno_stanje"; victim_explicit_request = "da"; suicide_outcome = "pokusano" |
| rule28 | crime_art149_3 | special_action_types = "navodjenje_na_samoubistvo"; victim_status = "maloljetnik" |
| rule29 | crime_art149_3 | special_action_types = "navodjenje_na_samoubistvo"; victim_accountability = "bitno_smanjena_uracunljivost" |
| rule30 | crime_art149_4 | special_action_types = "navodjenje_na_samoubistvo"; victim_status = "dijete" |
| rule31 | crime_art149_4 | special_action_types = "navodjenje_na_samoubistvo"; victim_accountability = "neuracunljivo" |
| rule32 | crime_art149_5 | inhuman_treatment = "true"; suicide_outcome = "izvrseno" |
| rule33 | crime_art149_5 | inhuman_treatment = "true"; suicide_outcome = "pokusano" |
| rule34 | crime_art150 | special_action_types = "nelegalni_pobacaj"; victim_consent = "pristanak" |
| rule35 | crime_art150 | DEPRECATED / inactive placeholder; broad outcome-only trigger removed |
| rule36 | crime_art150 | special_action_types = "nelegalni_pobacaj"; victim_consent = "bez_pristanka" |
| rule37 | crime_art150 | special_action_types = "nelegalni_pobacaj"; victim_status = "maloljetna_trudnica"; victim_consent = "bez_pristanka" |
| rule38 | REMOVED | Generic outcome-only mapping removed; see rule38b/rule39b/rule40b -> crime_art150_3 |
| rule39 | crime_art150 | special_action_types = "nelegalni_pobacaj"; abortion_outcomes = "tesko_narusavanje_zdravlja" |
| rule40 | REMOVED | Generic outcome-only mapping removed; see rule38b/rule39b/rule40b -> crime_art150_3 |
| rule41 | crime_art151_1 | injury_type = "teska tjelesna povreda" |
| rule42 | crime_art151_2 | DEPRECATED / inactive placeholder; slot retained for numbering stability |
| rule43 | crime_art151_2 | injury_type = "teska tjelesna povreda"; severe_injury_specific_consequences = "opasnost_po_zivot" |
| rule44 | crime_art151_3 | injury_type = "teska tjelesna povreda"; death_result = "true" |
| rule45 | crime_art151_4 | injury_type = "teska tjelesna povreda"; negligence = "true" |
| rule46 | crime_art151_5 | injury_type = "teska tjelesna povreda"; execution_manner = "na_mah" |
| rule47 | crime_art151a | special_action_types = "sakacenje_zenskih_genitalija" |
| rule48 | crime_art151b | special_action_types = "prisilna_sterilizacija" |
| rule49 | crime_art151b | sterilization_goal = "onemogucavanje_reprodukcije" |
| rule50 | crime_art152_1 | injury_type = "laka tjelesna povreda" |
| rule51 | crime_art152_2 | injury_type = "laka tjelesna povreda"; weapon_used = "true" |
| rule52 | crime_art152_2 | injury_means_type = "opasno_orudje"; injury_severity_level = "laka" |
| rule53 | crime_art152_2 | injury_means_type = "sredstvo_podobno_za_tesku_povredu"; injury_severity_level = "laka" |
| rule54 | crime_art153 | fight_participation = "true"; death_result = "true" |
| rule55 | crime_art153 | fight_participation = "true"; injury_type = "teska tjelesna povreda" |
| rule56 | crime_art154 | fight_participation = "true"; weapon_used = "true" |
| rule57 | crime_art154 | fight_participation = "true"; injury_means_type = "opasno_orudje" |
| rule58 | crime_art155_1 | danger_caused_by_offender = "true"; left_without_help = "true"; (danger_to_life = "true" OR danger_to_health = "true") |
| rule59 | crime_art155_2 | danger_caused_by_offender = "true"; (danger_to_health = "true" OR danger_to_life = "true"); left_without_help = "true"; failure_to_help_consequence = "tesko_narusavanje_zdravlja" |
| rule60 | crime_art155_3 | danger_caused_by_offender = "true"; (danger_to_life = "true" OR danger_to_health = "true"); left_without_help = "true"; failure_to_help_consequence = "smrt" |
| rule61 | crime_art156 | left_without_help = "true"; offender_victim_relationship = "povjereno_nemocno_lice" |
| rule62 | crime_art156 | left_without_help = "true"; offender_victim_relationship = "duznost_staranja" |
| rule63 | crime_art156_2 | left_without_help = "true"; offender_victim_relationship = "povjereno_nemocno_lice"; failure_to_help_consequence = "teska_tjelesna_povreda" |
| rule64 | crime_art156_2 | left_without_help = "true"; offender_victim_relationship = "duznost_staranja"; failure_to_help_consequence = "teska_tjelesna_povreda" |
| rule65 | crime_art156_3 | left_without_help = "true"; offender_victim_relationship = "povjereno_nemocno_lice"; failure_to_help_consequence = "smrt" |
| rule66 | crime_art156_3 | left_without_help = "true"; offender_victim_relationship = "duznost_staranja"; failure_to_help_consequence = "smrt" |
| rule67 | crime_art157 | left_without_help = "true"; offender_victim_relationship = "prolaznik"; help_provision_ability = "mogao_bez_opasnosti" |
| rule68 | crime_art157_2 | left_without_help = "true"; offender_victim_relationship = "prolaznik"; help_provision_ability = "mogao_bez_opasnosti"; failure_to_help_consequence = "teska_tjelesna_povreda" |
| rule69 | crime_art157_3 | left_without_help = "true"; offender_victim_relationship = "prolaznik"; help_provision_ability = "mogao_bez_opasnosti"; failure_to_help_consequence = "smrt" |
| rule70 | crime_art149_1 | special_action_types = "pomaganje_u_samoubistvu"; suicide_outcome = "izvrseno" |
| rule71 | crime_art149_1 | special_action_types = "pomaganje_u_samoubistvu"; suicide_outcome = "pokusano" |
| rule72 | crime_art149_4 | special_action_types = "pomaganje_u_samoubistvu"; victim_status = "dijete" |
| rule73 | crime_art149_4 | special_action_types = "pomaganje_u_samoubistvu"; victim_accountability = "neuracunljivo" |
