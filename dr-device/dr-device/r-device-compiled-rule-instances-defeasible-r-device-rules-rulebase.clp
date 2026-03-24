([rule10-defeasibly-dot] of derived-attribute-rule
   (pos-name rule10-defeasibly-dot-gen125)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule10] ) ) ) ?gen105 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule10 $? ) ) ( test ( eq ( class ?gen105 ) crime_art155_1 ) ) ( not ( and ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art155_1 ( negative ~ 2 ) ( positive-overruled $?gen107 & : ( not ( member$ rule10 $?gen107 ) ) ) ) ) ) => ?gen105 <- ( crime_art155_1 ( positive 0 ) )"))

([rule10-defeasibly] of derived-attribute-rule
   (pos-name rule10-defeasibly-gen127)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule10] ) ) ) ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen107 & : ( not ( member$ rule10 $?gen107 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art155_1 ) ) => ?gen105 <- ( crime_art155_1 ( positive 1 ) ( positive-derivator rule10 ?gen112 ?gen114 ) )"))

([rule10-overruled-dot] of derived-attribute-rule
   (pos-name rule10-overruled-dot-gen129)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule10] ) ) ) ?gen105 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen108 ) ( negative-overruled $?gen109 & : ( subseq-pos ( create$ rule10-overruled $?gen108 $$$ $?gen109 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art155_1 ) ) ( not ( and ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art155_1 ( positive-defeated $?gen107 & : ( not ( member$ rule10 $?gen107 ) ) ) ) ) ) => ( calc ( bind $?gen110 ( delete-member$ $?gen109 ( create$ rule10-overruled $?gen108 ) ) ) ) ?gen105 <- ( crime_art155_1 ( negative-overruled $?gen110 ) )"))

([rule10-overruled] of derived-attribute-rule
   (pos-name rule10-overruled-gen131)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule10] ) ) ) ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen108 ) ( negative-overruled $?gen109 & : ( not ( subseq-pos ( create$ rule10-overruled $?gen108 $$$ $?gen109 ) ) ) ) ( positive-defeated $?gen107 & : ( not ( member$ rule10 $?gen107 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art155_1 ) ) => ( calc ( bind $?gen110 ( create$ rule10-overruled $?gen108 $?gen109 ) ) ) ?gen105 <- ( crime_art155_1 ( negative-overruled $?gen110 ) )"))

([rule10-support] of derived-attribute-rule
   (pos-name rule10-support-gen133)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule10] ) ) ) ?gen103 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen105 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive-support $?gen107 & : ( not ( subseq-pos ( create$ rule10 ?gen103 ?gen104 $$$ $?gen107 ) ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art155_1 ) ) => ( calc ( bind $?gen110 ( create$ rule10 ?gen103 ?gen104 $?gen107 ) ) ) ?gen105 <- ( crime_art155_1 ( positive-support $?gen110 ) )"))

([rule9-defeasibly-dot] of derived-attribute-rule
   (pos-name rule9-defeasibly-dot-gen135)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule9] ) ) ) ?gen93 <- ( crime_art154 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule9 $? ) ) ( test ( eq ( class ?gen93 ) crime_art154 ) ) ( not ( and ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art154 ( negative ~ 2 ) ( positive-overruled $?gen95 & : ( not ( member$ rule9 $?gen95 ) ) ) ) ) ) => ?gen93 <- ( crime_art154 ( positive 0 ) )"))

([rule9-defeasibly] of derived-attribute-rule
   (pos-name rule9-defeasibly-gen137)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule9] ) ) ) ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art154 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen95 & : ( not ( member$ rule9 $?gen95 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art154 ) ) => ?gen93 <- ( crime_art154 ( positive 1 ) ( positive-derivator rule9 ?gen100 ?gen102 ) )"))

([rule9-overruled-dot] of derived-attribute-rule
   (pos-name rule9-overruled-dot-gen139)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule9] ) ) ) ?gen93 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen96 ) ( negative-overruled $?gen97 & : ( subseq-pos ( create$ rule9-overruled $?gen96 $$$ $?gen97 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art154 ) ) ( not ( and ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art154 ( positive-defeated $?gen95 & : ( not ( member$ rule9 $?gen95 ) ) ) ) ) ) => ( calc ( bind $?gen98 ( delete-member$ $?gen97 ( create$ rule9-overruled $?gen96 ) ) ) ) ?gen93 <- ( crime_art154 ( negative-overruled $?gen98 ) )"))

([rule9-overruled] of derived-attribute-rule
   (pos-name rule9-overruled-gen141)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule9] ) ) ) ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen96 ) ( negative-overruled $?gen97 & : ( not ( subseq-pos ( create$ rule9-overruled $?gen96 $$$ $?gen97 ) ) ) ) ( positive-defeated $?gen95 & : ( not ( member$ rule9 $?gen95 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art154 ) ) => ( calc ( bind $?gen98 ( create$ rule9-overruled $?gen96 $?gen97 ) ) ) ?gen93 <- ( crime_art154 ( negative-overruled $?gen98 ) )"))

([rule9-support] of derived-attribute-rule
   (pos-name rule9-support-gen143)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule9] ) ) ) ?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen92 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen93 <- ( crime_art154 ( defendant ?Defendant ) ( positive-support $?gen95 & : ( not ( subseq-pos ( create$ rule9 ?gen91 ?gen92 $$$ $?gen95 ) ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art154 ) ) => ( calc ( bind $?gen98 ( create$ rule9 ?gen91 ?gen92 $?gen95 ) ) ) ?gen93 <- ( crime_art154 ( positive-support $?gen98 ) )"))

([rule8-defeasibly-dot] of derived-attribute-rule
   (pos-name rule8-defeasibly-dot-gen145)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule8] ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule8 $? ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) ( not ( and ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( negative ~ 2 ) ( positive-overruled $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ) ) => ?gen81 <- ( crime_art153 ( positive 0 ) )"))

([rule8-defeasibly] of derived-attribute-rule
   (pos-name rule8-defeasibly-gen147)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule8] ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ?gen81 <- ( crime_art153 ( positive 1 ) ( positive-derivator rule8 ?gen88 ?gen90 ) )"))

([rule8-overruled-dot] of derived-attribute-rule
   (pos-name rule8-overruled-dot-gen149)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule8] ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen84 ) ( negative-overruled $?gen85 & : ( subseq-pos ( create$ rule8-overruled $?gen84 $$$ $?gen85 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) ( not ( and ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( positive-defeated $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ) ) => ( calc ( bind $?gen86 ( delete-member$ $?gen85 ( create$ rule8-overruled $?gen84 ) ) ) ) ?gen81 <- ( crime_art153 ( negative-overruled $?gen86 ) )"))

([rule8-overruled] of derived-attribute-rule
   (pos-name rule8-overruled-gen151)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule8] ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen84 ) ( negative-overruled $?gen85 & : ( not ( subseq-pos ( create$ rule8-overruled $?gen84 $$$ $?gen85 ) ) ) ) ( positive-defeated $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ( calc ( bind $?gen86 ( create$ rule8-overruled $?gen84 $?gen85 ) ) ) ?gen81 <- ( crime_art153 ( negative-overruled $?gen86 ) )"))

([rule8-support] of derived-attribute-rule
   (pos-name rule8-support-gen153)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule8] ) ) ) ?gen79 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen80 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive-support $?gen83 & : ( not ( subseq-pos ( create$ rule8 ?gen79 ?gen80 $$$ $?gen83 ) ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ( calc ( bind $?gen86 ( create$ rule8 ?gen79 ?gen80 $?gen83 ) ) ) ?gen81 <- ( crime_art153 ( positive-support $?gen86 ) )"))

([rule7-defeasibly-dot] of derived-attribute-rule
   (pos-name rule7-defeasibly-dot-gen155)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule7] ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule7 $? ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) ( not ( and ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ) ) => ?gen69 <- ( crime_art152_2 ( positive 0 ) )"))

([rule7-defeasibly] of derived-attribute-rule
   (pos-name rule7-defeasibly-gen157)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule7] ) ) ) ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ?gen69 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule7 ?gen76 ?gen78 ) )"))

([rule7-overruled-dot] of derived-attribute-rule
   (pos-name rule7-overruled-dot-gen159)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule7] ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen72 ) ( negative-overruled $?gen73 & : ( subseq-pos ( create$ rule7-overruled $?gen72 $$$ $?gen73 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) ( not ( and ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( positive-defeated $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ) ) => ( calc ( bind $?gen74 ( delete-member$ $?gen73 ( create$ rule7-overruled $?gen72 ) ) ) ) ?gen69 <- ( crime_art152_2 ( negative-overruled $?gen74 ) )"))

([rule7-overruled] of derived-attribute-rule
   (pos-name rule7-overruled-gen161)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule7] ) ) ) ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen72 ) ( negative-overruled $?gen73 & : ( not ( subseq-pos ( create$ rule7-overruled $?gen72 $$$ $?gen73 ) ) ) ) ( positive-defeated $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ( calc ( bind $?gen74 ( create$ rule7-overruled $?gen72 $?gen73 ) ) ) ?gen69 <- ( crime_art152_2 ( negative-overruled $?gen74 ) )"))

([rule7-support] of derived-attribute-rule
   (pos-name rule7-support-gen163)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule7] ) ) ) ?gen67 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen68 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen71 & : ( not ( subseq-pos ( create$ rule7 ?gen67 ?gen68 $$$ $?gen71 ) ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ( calc ( bind $?gen74 ( create$ rule7 ?gen67 ?gen68 $?gen71 ) ) ) ?gen69 <- ( crime_art152_2 ( positive-support $?gen74 ) )"))

([rule6-defeasibly-dot] of derived-attribute-rule
   (pos-name rule6-defeasibly-dot-gen165)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule6] ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule6 $? ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) ( not ( and ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( negative ~ 2 ) ( positive-overruled $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ) ) => ?gen59 <- ( crime_art152_1 ( positive 0 ) )"))

([rule6-defeasibly] of derived-attribute-rule
   (pos-name rule6-defeasibly-gen167)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule6] ) ) ) ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ?gen59 <- ( crime_art152_1 ( positive 1 ) ( positive-derivator rule6 ?gen66 ) )"))

([rule6-overruled-dot] of derived-attribute-rule
   (pos-name rule6-overruled-dot-gen169)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule6] ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen62 ) ( negative-overruled $?gen63 & : ( subseq-pos ( create$ rule6-overruled $?gen62 $$$ $?gen63 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) ( not ( and ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( positive-defeated $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ) ) => ( calc ( bind $?gen64 ( delete-member$ $?gen63 ( create$ rule6-overruled $?gen62 ) ) ) ) ?gen59 <- ( crime_art152_1 ( negative-overruled $?gen64 ) )"))

([rule6-overruled] of derived-attribute-rule
   (pos-name rule6-overruled-gen171)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule6] ) ) ) ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen62 ) ( negative-overruled $?gen63 & : ( not ( subseq-pos ( create$ rule6-overruled $?gen62 $$$ $?gen63 ) ) ) ) ( positive-defeated $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ( calc ( bind $?gen64 ( create$ rule6-overruled $?gen62 $?gen63 ) ) ) ?gen59 <- ( crime_art152_1 ( negative-overruled $?gen64 ) )"))

([rule6-support] of derived-attribute-rule
   (pos-name rule6-support-gen173)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule6] ) ) ) ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive-support $?gen61 & : ( not ( subseq-pos ( create$ rule6 ?gen58 $$$ $?gen61 ) ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ( calc ( bind $?gen64 ( create$ rule6 ?gen58 $?gen61 ) ) ) ?gen59 <- ( crime_art152_1 ( positive-support $?gen64 ) )"))

([rule5-defeasibly-dot] of derived-attribute-rule
   (pos-name rule5-defeasibly-dot-gen175)
   (depends-on declare crime_art151_5 lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule5] ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule5 $? ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) ( not ( and ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( negative ~ 2 ) ( positive-overruled $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ) ) => ?gen48 <- ( crime_art151_5 ( positive 0 ) )"))

([rule5-defeasibly] of derived-attribute-rule
   (pos-name rule5-defeasibly-gen177)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule5] ) ) ) ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ?gen48 <- ( crime_art151_5 ( positive 1 ) ( positive-derivator rule5 ?gen55 ?gen57 ) )"))

([rule5-overruled-dot] of derived-attribute-rule
   (pos-name rule5-overruled-dot-gen179)
   (depends-on declare crime_art151_5 lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule5] ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen51 ) ( negative-overruled $?gen52 & : ( subseq-pos ( create$ rule5-overruled $?gen51 $$$ $?gen52 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) ( not ( and ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( positive-defeated $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ) ) => ( calc ( bind $?gen53 ( delete-member$ $?gen52 ( create$ rule5-overruled $?gen51 ) ) ) ) ?gen48 <- ( crime_art151_5 ( negative-overruled $?gen53 ) )"))

([rule5-overruled] of derived-attribute-rule
   (pos-name rule5-overruled-gen181)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule5] ) ) ) ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen51 ) ( negative-overruled $?gen52 & : ( not ( subseq-pos ( create$ rule5-overruled $?gen51 $$$ $?gen52 ) ) ) ) ( positive-defeated $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ( calc ( bind $?gen53 ( create$ rule5-overruled $?gen51 $?gen52 ) ) ) ?gen48 <- ( crime_art151_5 ( negative-overruled $?gen53 ) )"))

([rule5-support] of derived-attribute-rule
   (pos-name rule5-support-gen183)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule5] ) ) ) ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen47 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive-support $?gen50 & : ( not ( subseq-pos ( create$ rule5 ?gen46 ?gen47 $$$ $?gen50 ) ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ( calc ( bind $?gen53 ( create$ rule5 ?gen46 ?gen47 $?gen50 ) ) ) ?gen48 <- ( crime_art151_5 ( positive-support $?gen53 ) )"))

([rule4-defeasibly-dot] of derived-attribute-rule
   (pos-name rule4-defeasibly-dot-gen185)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule4] ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule4 $? ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) ( not ( and ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( negative ~ 2 ) ( positive-overruled $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ) ) => ?gen36 <- ( crime_art151_4 ( positive 0 ) )"))

([rule4-defeasibly] of derived-attribute-rule
   (pos-name rule4-defeasibly-gen187)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule4] ) ) ) ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ?gen36 <- ( crime_art151_4 ( positive 1 ) ( positive-derivator rule4 ?gen43 ?gen45 ) )"))

([rule4-overruled-dot] of derived-attribute-rule
   (pos-name rule4-overruled-dot-gen189)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule4] ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen39 ) ( negative-overruled $?gen40 & : ( subseq-pos ( create$ rule4-overruled $?gen39 $$$ $?gen40 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) ( not ( and ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( positive-defeated $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ) ) => ( calc ( bind $?gen41 ( delete-member$ $?gen40 ( create$ rule4-overruled $?gen39 ) ) ) ) ?gen36 <- ( crime_art151_4 ( negative-overruled $?gen41 ) )"))

([rule4-overruled] of derived-attribute-rule
   (pos-name rule4-overruled-gen191)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule4] ) ) ) ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen39 ) ( negative-overruled $?gen40 & : ( not ( subseq-pos ( create$ rule4-overruled $?gen39 $$$ $?gen40 ) ) ) ) ( positive-defeated $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ( calc ( bind $?gen41 ( create$ rule4-overruled $?gen39 $?gen40 ) ) ) ?gen36 <- ( crime_art151_4 ( negative-overruled $?gen41 ) )"))

([rule4-support] of derived-attribute-rule
   (pos-name rule4-support-gen193)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule4] ) ) ) ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen35 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive-support $?gen38 & : ( not ( subseq-pos ( create$ rule4 ?gen34 ?gen35 $$$ $?gen38 ) ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ( calc ( bind $?gen41 ( create$ rule4 ?gen34 ?gen35 $?gen38 ) ) ) ?gen36 <- ( crime_art151_4 ( positive-support $?gen41 ) )"))

([rule3-defeasibly-dot] of derived-attribute-rule
   (pos-name rule3-defeasibly-dot-gen195)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule3] ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule3 $? ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) ( not ( and ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( negative ~ 2 ) ( positive-overruled $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ) ) => ?gen24 <- ( crime_art151_3 ( positive 0 ) )"))

([rule3-defeasibly] of derived-attribute-rule
   (pos-name rule3-defeasibly-gen197)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule3] ) ) ) ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ?gen24 <- ( crime_art151_3 ( positive 1 ) ( positive-derivator rule3 ?gen31 ?gen33 ) )"))

([rule3-overruled-dot] of derived-attribute-rule
   (pos-name rule3-overruled-dot-gen199)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule3] ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen27 ) ( negative-overruled $?gen28 & : ( subseq-pos ( create$ rule3-overruled $?gen27 $$$ $?gen28 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) ( not ( and ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( positive-defeated $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ) ) => ( calc ( bind $?gen29 ( delete-member$ $?gen28 ( create$ rule3-overruled $?gen27 ) ) ) ) ?gen24 <- ( crime_art151_3 ( negative-overruled $?gen29 ) )"))

([rule3-overruled] of derived-attribute-rule
   (pos-name rule3-overruled-gen201)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule3] ) ) ) ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen27 ) ( negative-overruled $?gen28 & : ( not ( subseq-pos ( create$ rule3-overruled $?gen27 $$$ $?gen28 ) ) ) ) ( positive-defeated $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ( calc ( bind $?gen29 ( create$ rule3-overruled $?gen27 $?gen28 ) ) ) ?gen24 <- ( crime_art151_3 ( negative-overruled $?gen29 ) )"))

([rule3-support] of derived-attribute-rule
   (pos-name rule3-support-gen203)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule3] ) ) ) ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen23 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive-support $?gen26 & : ( not ( subseq-pos ( create$ rule3 ?gen22 ?gen23 $$$ $?gen26 ) ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ( calc ( bind $?gen29 ( create$ rule3 ?gen22 ?gen23 $?gen26 ) ) ) ?gen24 <- ( crime_art151_3 ( positive-support $?gen29 ) )"))

([rule2-defeasibly-dot] of derived-attribute-rule
   (pos-name rule2-defeasibly-dot-gen205)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule2] ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule2 $? ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) ( not ( and ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ) ) => ?gen12 <- ( crime_art151_2 ( positive 0 ) )"))

([rule2-defeasibly] of derived-attribute-rule
   (pos-name rule2-defeasibly-gen207)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule2] ) ) ) ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ?gen12 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule2 ?gen19 ?gen21 ) )"))

([rule2-overruled-dot] of derived-attribute-rule
   (pos-name rule2-overruled-dot-gen209)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule2] ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen15 ) ( negative-overruled $?gen16 & : ( subseq-pos ( create$ rule2-overruled $?gen15 $$$ $?gen16 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) ( not ( and ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( positive-defeated $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ) ) => ( calc ( bind $?gen17 ( delete-member$ $?gen16 ( create$ rule2-overruled $?gen15 ) ) ) ) ?gen12 <- ( crime_art151_2 ( negative-overruled $?gen17 ) )"))

([rule2-overruled] of derived-attribute-rule
   (pos-name rule2-overruled-gen211)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule2] ) ) ) ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen15 ) ( negative-overruled $?gen16 & : ( not ( subseq-pos ( create$ rule2-overruled $?gen15 $$$ $?gen16 ) ) ) ) ( positive-defeated $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ( calc ( bind $?gen17 ( create$ rule2-overruled $?gen15 $?gen16 ) ) ) ?gen12 <- ( crime_art151_2 ( negative-overruled $?gen17 ) )"))

([rule2-support] of derived-attribute-rule
   (pos-name rule2-support-gen213)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule2] ) ) ) ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen11 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen14 & : ( not ( subseq-pos ( create$ rule2 ?gen10 ?gen11 $$$ $?gen14 ) ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ( calc ( bind $?gen17 ( create$ rule2 ?gen10 ?gen11 $?gen14 ) ) ) ?gen12 <- ( crime_art151_2 ( positive-support $?gen17 ) )"))

([rule1-defeasibly-dot] of derived-attribute-rule
   (pos-name rule1-defeasibly-dot-gen215)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule1] ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule1 $? ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) ( not ( and ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( negative ~ 2 ) ( positive-overruled $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ) ) => ?gen2 <- ( crime_art151_1 ( positive 0 ) )"))

([rule1-defeasibly] of derived-attribute-rule
   (pos-name rule1-defeasibly-gen217)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule1] ) ) ) ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ?gen2 <- ( crime_art151_1 ( positive 1 ) ( positive-derivator rule1 ?gen9 ) )"))

([rule1-overruled-dot] of derived-attribute-rule
   (pos-name rule1-overruled-dot-gen219)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule1] ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen5 ) ( negative-overruled $?gen6 & : ( subseq-pos ( create$ rule1-overruled $?gen5 $$$ $?gen6 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) ( not ( and ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( positive-defeated $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ) ) => ( calc ( bind $?gen7 ( delete-member$ $?gen6 ( create$ rule1-overruled $?gen5 ) ) ) ) ?gen2 <- ( crime_art151_1 ( negative-overruled $?gen7 ) )"))

([rule1-overruled] of derived-attribute-rule
   (pos-name rule1-overruled-gen221)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule1] ) ) ) ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen5 ) ( negative-overruled $?gen6 & : ( not ( subseq-pos ( create$ rule1-overruled $?gen5 $$$ $?gen6 ) ) ) ) ( positive-defeated $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ( calc ( bind $?gen7 ( create$ rule1-overruled $?gen5 $?gen6 ) ) ) ?gen2 <- ( crime_art151_1 ( negative-overruled $?gen7 ) )"))

([rule1-support] of derived-attribute-rule
   (pos-name rule1-support-gen223)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule1] ) ) ) ?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive-support $?gen4 & : ( not ( subseq-pos ( create$ rule1 ?gen1 $$$ $?gen4 ) ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ( calc ( bind $?gen7 ( create$ rule1 ?gen1 $?gen4 ) ) ) ?gen2 <- ( crime_art151_1 ( positive-support $?gen7 ) )"))

([rule10-deductive] of ntm-deductive-rule
   (pos-name rule10-deductive-gen124)
   (depends-on lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (deductive-rule "?gen103 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( not ( crime_art155_1 ( defendant ?Defendant ) ) ) => ( crime_art155_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule10-deductive-gen124 ( declare ( salience ( calc-salience crime_art155_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen103 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen104 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( not ( object ( is-a crime_art155_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_1))

([rule9-deductive] of ntm-deductive-rule
   (pos-name rule9-deductive-gen123)
   (depends-on lc:case lc:case crime_art154)
   (implies crime_art154)
   (deductive-rule "?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen92 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( not ( crime_art154 ( defendant ?Defendant ) ) ) => ( crime_art154 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule9-deductive-gen123 ( declare ( salience ( calc-salience crime_art154 ) ) ) ( run-deductive-rules ) ( object ( name ?gen91 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen92 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( not ( object ( is-a crime_art154 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ( make-instance ?oid of crime_art154 ( defendant ?Defendant ) ) )")
   (derived-class crime_art154))

([rule8-deductive] of ntm-deductive-rule
   (pos-name rule8-deductive-gen122)
   (depends-on lc:case lc:case crime_art153)
   (implies crime_art153)
   (deductive-rule "?gen79 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen80 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ( not ( crime_art153 ( defendant ?Defendant ) ) ) => ( crime_art153 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule8-deductive-gen122 ( declare ( salience ( calc-salience crime_art153 ) ) ) ( run-deductive-rules ) ( object ( name ?gen79 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen80 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ( not ( object ( is-a crime_art153 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ( make-instance ?oid of crime_art153 ( defendant ?Defendant ) ) )")
   (derived-class crime_art153))

([rule7-deductive] of ntm-deductive-rule
   (pos-name rule7-deductive-gen121)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen67 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen68 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule7-deductive-gen121 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen67 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( object ( name ?gen68 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule6-deductive] of ntm-deductive-rule
   (pos-name rule6-deductive-gen120)
   (depends-on lc:case crime_art152_1)
   (implies crime_art152_1)
   (deductive-rule "?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( crime_art152_1 ( defendant ?Defendant ) ) ) => ( crime_art152_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule6-deductive-gen120 ( declare ( salience ( calc-salience crime_art152_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen58 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( object ( is-a crime_art152_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_1))

([rule5-deductive] of ntm-deductive-rule
   (pos-name rule5-deductive-gen119)
   (depends-on lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (deductive-rule "?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen47 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( crime_art151_5 ( defendant ?Defendant ) ) ) => ( crime_art151_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule5-deductive-gen119 ( declare ( salience ( calc-salience crime_art151_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen46 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen47 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( object ( is-a crime_art151_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_5))

([rule4-deductive] of ntm-deductive-rule
   (pos-name rule4-deductive-gen118)
   (depends-on lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (deductive-rule "?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen35 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( crime_art151_4 ( defendant ?Defendant ) ) ) => ( crime_art151_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule4-deductive-gen118 ( declare ( salience ( calc-salience crime_art151_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen34 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen35 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( object ( is-a crime_art151_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_4))

([rule3-deductive] of ntm-deductive-rule
   (pos-name rule3-deductive-gen117)
   (depends-on lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (deductive-rule "?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen23 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ( not ( crime_art151_3 ( defendant ?Defendant ) ) ) => ( crime_art151_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule3-deductive-gen117 ( declare ( salience ( calc-salience crime_art151_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen22 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen23 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ( not ( object ( is-a crime_art151_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_3))

([rule2-deductive] of ntm-deductive-rule
   (pos-name rule2-deductive-gen116)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen11 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule2-deductive-gen116 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen10 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen11 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule1-deductive] of ntm-deductive-rule
   (pos-name rule1-deductive-gen115)
   (depends-on lc:case crime_art151_1)
   (implies crime_art151_1)
   (deductive-rule "?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( crime_art151_1 ( defendant ?Defendant ) ) ) => ( crime_art151_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule1-deductive-gen115 ( declare ( salience ( calc-salience crime_art151_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( object ( is-a crime_art151_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_1))

