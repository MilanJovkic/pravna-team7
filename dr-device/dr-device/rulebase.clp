(import-rdf "facts.rdf")
		(export-rdf export.rdf  crime_art151_1 crime_art151_2 crime_art151_3 crime_art151_4 crime_art151_5 crime_art152_1 crime_art152_2 crime_art153 crime_art154 crime_art155_1)
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
		 lc:injury_type "teska tjelesna povreda")
	)
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
		 lc:injury_type "teska tjelesna povreda")
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