(import-rdf "facts.rdf")
		(export-rdf export.rdf  crime_art143 crime_art144 crime_art145 crime_art146 crime_art147 crime_art148 crime_art149_1 crime_art149_2 crime_art149_5 crime_art150 crime_art151_1 crime_art151_2 crime_art151_3 crime_art151_4 crime_art151_5 crime_art151a crime_art151b crime_art152_1 crime_art152_2 crime_art153 crime_art154 crime_art155_1 crime_art156 crime_art157)
		(export-proof proof.ruleml)

(defeasiblerule rule1
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

(defeasiblerule rule2
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
		 lc:weapon_used "true")
	)
  =>
	(crime_art151_2
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule3
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
		 lc:severe_consequence "true")
	)
  =>
	(crime_art151_3
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule4
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
	(crime_art151_4
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule5
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
	(crime_art151_5
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule6
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

(defeasiblerule rule7
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

(defeasiblerule rule8
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
		 lc:provocation "true")
	)
  =>
	(crime_art153
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule9
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:fight_participation "true")
	)
  =>
	(crime_art154
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule10
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
		 lc:injury_type "teska tjelesna povreda")
	)
  =>
	(crime_art155_1
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
		 lc:guilt_form "umisljaj_direktni")
	)
  =>
	(crime_art143
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
		 lc:guilt_form "umisljaj_eventualni")
	)
  =>
	(crime_art143
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
		 lc:danger_to_third_parties "true")
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
		 lc:offender_psych_state "jaka_razdrazenost_na_mah")
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
  =>
	(crime_art146
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule20
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
		 lc:victim_explicit_request "da")
	)
  =>
	(crime_art147
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
		 lc:guilt_form "nehat")
	)
  =>
	(crime_art148
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule22
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:suicide_outcome "izvrseno")
	)
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:special_action_types "navodjenje_na_samoubistvo")
	)
  =>
	(crime_art149_1
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule23
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:suicide_outcome "izvrseno")
	)
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:special_action_types "pomaganje_u_samoubistvu")
	)
  =>
	(crime_art149_2
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule24
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:suicide_outcome "pokusano")
	)
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:inhuman_treatment "true")
	)
  =>
	(crime_art149_5
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule25
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:special_action_types "nelegalni_pobacaj")
	)
  =>
	(crime_art150
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule26
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

(defeasiblerule rule27
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:special_action_types "prisilna_sterilizacija")
	)
  =>
	(crime_art151b
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule28
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:sterilization_goal "onemogucavanje_reprodukcije")
	)
  =>
	(crime_art151b
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule29
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

(defeasiblerule rule30
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

(defeasiblerule rule31
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

(defeasiblerule rule32
	(lc:case
		(
		 lc:defendant ?Defendant)
		(
		 lc:abortion_outcomes "pobacaj_izvrsen")
	)
  =>
	(crime_art150
		(
		 defendant ?Defendant)
	)
)

(defeasiblerule rule33
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

(defeasiblerule rule34
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
  =>
	(crime_art155_1
		(
		 defendant ?Defendant)
	)
)
