(import-rdf "facts.rdf")
		(export-rdf export.rdf  crime_art143 crime_art144 crime_art145 crime_art146 crime_art147 crime_art148 crime_art149_1 crime_art149_2 crime_art149_3 crime_art149_4 crime_art149_5 crime_art150_1 crime_art150_2 crime_art150_3 crime_art151_1 crime_art151_2 crime_art151_3 crime_art151_4 crime_art151_5 crime_art151a crime_art151b crime_art152_1 crime_art152_2 crime_art152_3 crime_art153 crime_art154 crime_art155_1 crime_art155_2 crime_art155_3 crime_art156 crime_art156_2 crime_art156_3 crime_art157 crime_art157_2 crime_art157_3)
(export-proof proof.ruleml)

(defeasiblerule rule1
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:guilt_form "umisljaj_direktni")
)
  =>
(crime_art143
(
 defendant ?Defendant)
)
)

(defeasiblerule rule2
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:guilt_form "umisljaj_eventualni")
)
  =>
(crime_art143
(
 defendant ?Defendant)
)
)

(defeasiblerule rule4
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "svirep")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule5
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "podmukao")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule6
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "bezobzirno_nasilnicko_ponasanje")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule7
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:guilt_form "umisljaj_direktni")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:danger_to_third_parties "true")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule7b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:guilt_form "umisljaj_eventualni")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:danger_to_third_parties "true")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule8
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_motive "koristoljublje")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule9
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_motive "izvrsenje_ili_prikrivanje_drugog_krivicnog_djela")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule9b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_motive "niske_pobude")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule10
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_motive "bezobzirna_osveta")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule11
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "sluzbeno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:duty_connection "u_vrsenju_sluzbene_duznosti")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule12
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "vojno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:duty_connection "u_vrsenju_sluzbene_duznosti")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule13
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule14
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "bremenita_zena")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule15
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "clan_porodice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_previously_abused "true")
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule16
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_count "vise")
)
(or
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:guilt_form "umisljaj_direktni")
  )
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:guilt_form "umisljaj_eventualni")
  )
)
(not (lc:case (lc:defendant ?Defendant) (lc:execution_manner "na_mah")))
(not (lc:case (lc:defendant ?Defendant) (lc:offender_psych_state "porodjajni_poremecaj")))
(not (and
  (lc:case (lc:defendant ?Defendant) (lc:victim_status "punoljetno_lice"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_health_state "tesko_zdravstveno_stanje"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_explicit_request "da"))
  (lc:case (lc:defendant ?Defendant) (lc:offender_motive "samilost"))
))
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule17
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "na_mah")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "napad_od_ubijenog")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "bez_krivice_ucinioca")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:high_intensity_distress "true")
)
  =>
(crime_art145
(
 defendant ?Defendant)
)
)

(defeasiblerule rule18
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "na_mah")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "zlostavljanje_od_ubijenog")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "bez_krivice_ucinioca")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:high_intensity_distress "true")
)
  =>
(crime_art145
(
 defendant ?Defendant)
)
)

(defeasiblerule rule18b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "na_mah")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "tesko_vrijedjanje_od_ubijenog")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "bez_krivice_ucinioca")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:high_intensity_distress "true")
)
  =>
(crime_art145
(
 defendant ?Defendant)
)
)

(defeasiblerule rule19
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_psych_state "porodjajni_poremecaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_is_mother "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
  =>
(crime_art146
(
 defendant ?Defendant)
)
)

(defeasiblerule rule21
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "punoljetno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_health_state "tesko_zdravstveno_stanje")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_explicit_request "da")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_motive "samilost")
)
  =>
(crime_art147
(
 defendant ?Defendant)
)
)

(defeasiblerule rule22
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:life_consequence_type "smrt_nastupila")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:guilt_form "nehat")
)
  =>
(crime_art148
(
 defendant ?Defendant)
)
)

(defeasiblerule rule24
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "izvrseno")
)
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "dijete")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "maloljetnik")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "neuracunljivo")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "bitno_smanjena_uracunljivost")))
  =>
(crime_art149_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule25
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "pokusano")
)
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "dijete")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "maloljetnik")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "neuracunljivo")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "bitno_smanjena_uracunljivost")))
  =>
(crime_art149_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule26
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "punoljetno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_health_state "tesko_zdravstveno_stanje")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_explicit_request "da")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "izvrseno")
)
  =>
(crime_art149_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule27
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "punoljetno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_health_state "tesko_zdravstveno_stanje")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_explicit_request "da")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "pokusano")
)
  =>
(crime_art149_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule29b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "bitno_smanjena_uracunljivost")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule28
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "maloljetnik")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule28b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "maloljetnik")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule29
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "bitno_smanjena_uracunljivost")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule30
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_4
(
 defendant ?Defendant)
)
)

(defeasiblerule rule30b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule31
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "neuracunljivo")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_4
(
 defendant ?Defendant)
)
)

(defeasiblerule rule31b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "navodjenje_na_samoubistvo")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "neuracunljivo")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule32
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:inhuman_treatment "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_subordination "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "izvrseno")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:guilt_form "nehat"))
  (lc:case (lc:defendant ?Defendant) (lc:death_attributed_to_negligence "da"))
)
  =>
(crime_art149_5
(
 defendant ?Defendant)
)
)

(defeasiblerule rule33
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:inhuman_treatment "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_subordination "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "pokusano")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:guilt_form "nehat"))
  (lc:case (lc:defendant ?Defendant) (lc:death_attributed_to_negligence "da"))
)
  =>
(crime_art149_5
(
 defendant ?Defendant)
)
)

(defeasiblerule rule34
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_consent "pristanak")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:abortion_action_mode "izvrsi_pobacaj")
)
  =>
(crime_art150_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule34b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_consent "pristanak")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:abortion_action_mode "pomogne_izvrsenje_pobacaja")
)
  =>
(crime_art150_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule36b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_consent "bez_pristanka")
)
  =>
(crime_art150_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule37
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "maloljetna_trudnica")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:victim_consent "bez_pristanka"))
  (lc:case (lc:defendant ?Defendant) (lc:guardian_consent "ne"))
)
  =>
(crime_art150_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule38b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:abortion_outcomes "smrt")
)
  =>
(crime_art150_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule39b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:abortion_outcomes "tesko_narusavanje_zdravlja")
)
  =>
(crime_art150_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule40b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "nelegalni_pobacaj")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:abortion_outcomes "teska_tjelesna_povreda")
)
  =>
(crime_art150_3
(
 defendant ?Defendant)
)
)
(defeasiblerule rule41
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
  =>
(crime_art151_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "opasnost_po_zivot")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "unistenje_dijela_tijela")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43c
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "trajno_ostecenje_organa")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43d
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "trajna_nesposobnost_za_rad")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43e
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "trajno_naruseno_zdravlje")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule43f
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:severe_injury_specific_consequences "unakazenost")
)
  =>
(crime_art151_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule44
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:death_result "true")
)
  =>
(crime_art151_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule45
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:negligence "true")
)
  =>
(crime_art151_4
(
 defendant ?Defendant)
)
)

(defeasiblerule rule46
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "na_mah")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "napad_od_ubijenog"))
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "zlostavljanje_od_ubijenog"))
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "tesko_vrijedjanje_od_ubijenog"))
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "bez_krivice_ucinioca")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:high_intensity_distress "true")
)
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "opasnost_po_zivot")))
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "unistenje_dijela_tijela")))
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajno_ostecenje_organa")))
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajna_nesposobnost_za_rad")))
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajno_naruseno_zdravlje")))
(not (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "unakazenost")))
(not (lc:case (lc:defendant ?Defendant) (lc:death_result "true")))
(not (lc:case (lc:defendant ?Defendant) (lc:guilt_form "nehat")))
  =>
(crime_art151_5
(
 defendant ?Defendant)
)
)

(defeasiblerule rule46b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:execution_manner "na_mah")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "napad_od_ubijenog"))
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "zlostavljanje_od_ubijenog"))
  (lc:case (lc:defendant ?Defendant) (lc:provocation_types "tesko_vrijedjanje_od_ubijenog"))
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation_types "bez_krivice_ucinioca")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:high_intensity_distress "true")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "opasnost_po_zivot"))
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "unistenje_dijela_tijela"))
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajno_ostecenje_organa"))
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajna_nesposobnost_za_rad"))
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "trajno_naruseno_zdravlje"))
  (lc:case (lc:defendant ?Defendant) (lc:severe_injury_specific_consequences "unakazenost"))
)
(not (lc:case (lc:defendant ?Defendant) (lc:death_result "true")))
(not (lc:case (lc:defendant ?Defendant) (lc:guilt_form "nehat")))
  =>
(crime_art151_5
(
 defendant ?Defendant)
)
)

(defeasiblerule rule47
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "sakacenje_zenskih_genitalija")
)
  =>
(crime_art151a
(
 defendant ?Defendant)
)
)

(defeasiblerule rule48
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "prisilna_sterilizacija")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_consent "bez_pristanka")
)
  =>
(crime_art151b
(
 defendant ?Defendant)
)
)

(defeasiblerule rule49
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "prisilna_sterilizacija")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:sterilization_goal "onemogucavanje_reprodukcije")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_consent "bez_pristanka")
)
  =>
(crime_art151b
(
 defendant ?Defendant)
)
)

(defeasiblerule rule50
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "laka tjelesna povreda")
)
  =>
(crime_art152_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule51
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "laka tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:weapon_used "true")
)
  =>
(crime_art152_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule52
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_means_type "opasno_orudje")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_severity_level "laka")
)
  =>
(crime_art152_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule53
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_means_type "sredstvo_podobno_za_tesku_povredu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_severity_level "laka")
)
  =>
(crime_art152_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule53b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "laka tjelesna povreda")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:provocation "true")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:weapon_used "true"))
  (lc:case (lc:defendant ?Defendant) (lc:injury_means_type "opasno_orudje"))
  (lc:case (lc:defendant ?Defendant) (lc:injury_means_type "sredstvo_podobno_za_tesku_povredu"))
)
  =>
(crime_art152_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule54
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:fight_participation "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:death_result "true")
)
  =>
(crime_art153
(
 defendant ?Defendant)
)
)

(defeasiblerule rule55
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:fight_participation "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_type "teska tjelesna povreda")
)
  =>
(crime_art153
(
 defendant ?Defendant)
)
)

(defeasiblerule rule56
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:fight_participation "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:weapon_used "true")
)
  =>
(crime_art154
(
 defendant ?Defendant)
)
)

(defeasiblerule rule57
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:fight_participation "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_means_type "opasno_orudje")
)
  =>
(crime_art154
(
 defendant ?Defendant)
)
)

(defeasiblerule rule57b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:fight_participation "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:injury_means_type "sredstvo_podobno_za_tesku_povredu")
)
  =>
(crime_art154
(
 defendant ?Defendant)
)
)

(defeasiblerule rule58
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:danger_caused_by_offender "true")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:danger_to_life "true"))
  (lc:case (lc:defendant ?Defendant) (lc:danger_to_health "true"))
)
  =>
(crime_art155_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule59
(or
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:danger_to_health "true")
  )
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:danger_to_life "true")
  )
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:danger_caused_by_offender "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "tesko_narusavanje_zdravlja")
)
  =>
(crime_art155_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule60
(or
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:danger_to_life "true")
  )
  (lc:case
  (
   lc:defendant ?Defendant)
  (
   lc:danger_to_health "true")
  )
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:danger_caused_by_offender "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "smrt")
)
  =>
(crime_art155_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule61
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "povjereno_nemocno_lice")
)
  =>
(crime_art156
(
 defendant ?Defendant)
)
)

(defeasiblerule rule62
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "duznost_staranja")
)
  =>
(crime_art156
(
 defendant ?Defendant)
)
)

(defeasiblerule rule63
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "povjereno_nemocno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "teska_tjelesna_povreda")
)
  =>
(crime_art156_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule64
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "duznost_staranja")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "teska_tjelesna_povreda")
)
  =>
(crime_art156_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule65
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "povjereno_nemocno_lice")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "smrt")
)
  =>
(crime_art156_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule66
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "duznost_staranja")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "smrt")
)
  =>
(crime_art156_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule67
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "prolaznik")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:help_provision_ability "mogao_bez_opasnosti")
)
  =>
(crime_art157
(
 defendant ?Defendant)
)
)

(defeasiblerule rule68
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "prolaznik")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:help_provision_ability "mogao_bez_opasnosti")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "teska_tjelesna_povreda")
)
  =>
(crime_art157_2
(
 defendant ?Defendant)
)
)

(defeasiblerule rule69
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:left_without_help "true")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:offender_victim_relationship "prolaznik")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:help_provision_ability "mogao_bez_opasnosti")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:failure_to_help_consequence "smrt")
)
  =>
(crime_art157_3
(
 defendant ?Defendant)
)
)

(defeasiblerule rule70
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "izvrseno")
)
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "maloljetnik")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "dijete")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "bitno_smanjena_uracunljivost")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "neuracunljivo")))
(not (and
  (lc:case (lc:defendant ?Defendant) (lc:victim_status "punoljetno_lice"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_health_state "tesko_zdravstveno_stanje"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_explicit_request "da"))
))
  =>
(crime_art149_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule71
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:suicide_outcome "pokusano")
)
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "maloljetnik")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_status "dijete")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "bitno_smanjena_uracunljivost")))
(not (lc:case (lc:defendant ?Defendant) (lc:victim_accountability "neuracunljivo")))
(not (and
  (lc:case (lc:defendant ?Defendant) (lc:victim_status "punoljetno_lice"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_health_state "tesko_zdravstveno_stanje"))
  (lc:case (lc:defendant ?Defendant) (lc:victim_explicit_request "da"))
))
  =>
(crime_art149_1
(
 defendant ?Defendant)
)
)

(defeasiblerule rule72
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_4
(
 defendant ?Defendant)
)
)

(defeasiblerule rule72b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_status "dijete")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)

(defeasiblerule rule73
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "neuracunljivo")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art149_4
(
 defendant ?Defendant)
)
)

(defeasiblerule rule73b
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:special_action_types "pomaganje_u_samoubistvu")
)
(lc:case
(
 lc:defendant ?Defendant)
(
 lc:victim_accountability "neuracunljivo")
)
(or
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "izvrseno"))
  (lc:case (lc:defendant ?Defendant) (lc:suicide_outcome "pokusano"))
)
  =>
(crime_art144
(
 defendant ?Defendant)
)
)


