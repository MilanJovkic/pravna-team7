([rule34-defeasibly-dot] of derived-attribute-rule
   (pos-name rule34-defeasibly-dot-gen422)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule34] ) ) ) ?gen378 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule34 $? ) ) ( test ( eq ( class ?gen378 ) crime_art155_1 ) ) ( not ( and ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen378 <- ( crime_art155_1 ( negative ~ 2 ) ( positive-overruled $?gen380 & : ( not ( member$ rule34 $?gen380 ) ) ) ) ) ) => ?gen378 <- ( crime_art155_1 ( positive 0 ) )"))

([rule34-defeasibly] of derived-attribute-rule
   (pos-name rule34-defeasibly-gen424)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule34] ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen378 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen380 & : ( not ( member$ rule34 $?gen380 ) ) ) ) ( test ( eq ( class ?gen378 ) crime_art155_1 ) ) => ?gen378 <- ( crime_art155_1 ( positive 1 ) ( positive-derivator rule34 ?gen385 ?gen387 ) )"))

([rule34-overruled-dot] of derived-attribute-rule
   (pos-name rule34-overruled-dot-gen426)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule34] ) ) ) ?gen378 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen381 ) ( negative-overruled $?gen382 & : ( subseq-pos ( create$ rule34-overruled $?gen381 $$$ $?gen382 ) ) ) ) ( test ( eq ( class ?gen378 ) crime_art155_1 ) ) ( not ( and ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen378 <- ( crime_art155_1 ( positive-defeated $?gen380 & : ( not ( member$ rule34 $?gen380 ) ) ) ) ) ) => ( calc ( bind $?gen383 ( delete-member$ $?gen382 ( create$ rule34-overruled $?gen381 ) ) ) ) ?gen378 <- ( crime_art155_1 ( negative-overruled $?gen383 ) )"))

([rule34-overruled] of derived-attribute-rule
   (pos-name rule34-overruled-gen428)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule34] ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen378 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen381 ) ( negative-overruled $?gen382 & : ( not ( subseq-pos ( create$ rule34-overruled $?gen381 $$$ $?gen382 ) ) ) ) ( positive-defeated $?gen380 & : ( not ( member$ rule34 $?gen380 ) ) ) ) ( test ( eq ( class ?gen378 ) crime_art155_1 ) ) => ( calc ( bind $?gen383 ( create$ rule34-overruled $?gen381 $?gen382 ) ) ) ?gen378 <- ( crime_art155_1 ( negative-overruled $?gen383 ) )"))

([rule34-support] of derived-attribute-rule
   (pos-name rule34-support-gen430)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule34] ) ) ) ?gen376 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen377 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen378 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive-support $?gen380 & : ( not ( subseq-pos ( create$ rule34 ?gen376 ?gen377 $$$ $?gen380 ) ) ) ) ) ( test ( eq ( class ?gen378 ) crime_art155_1 ) ) => ( calc ( bind $?gen383 ( create$ rule34 ?gen376 ?gen377 $?gen380 ) ) ) ?gen378 <- ( crime_art155_1 ( positive-support $?gen383 ) )"))

([rule33-defeasibly-dot] of derived-attribute-rule
   (pos-name rule33-defeasibly-dot-gen432)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule33] ) ) ) ?gen366 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule33 $? ) ) ( test ( eq ( class ?gen366 ) crime_art152_2 ) ) ( not ( and ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen372 & : ( >= ?gen372 1 ) ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen374 & : ( >= ?gen374 1 ) ) ) ?gen366 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen368 & : ( not ( member$ rule33 $?gen368 ) ) ) ) ) ) => ?gen366 <- ( crime_art152_2 ( positive 0 ) )"))

([rule33-defeasibly] of derived-attribute-rule
   (pos-name rule33-defeasibly-gen434)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule33] ) ) ) ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen372 & : ( >= ?gen372 1 ) ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen374 & : ( >= ?gen374 1 ) ) ) ?gen366 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen368 & : ( not ( member$ rule33 $?gen368 ) ) ) ) ( test ( eq ( class ?gen366 ) crime_art152_2 ) ) => ?gen366 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule33 ?gen373 ?gen375 ) )"))

([rule33-overruled-dot] of derived-attribute-rule
   (pos-name rule33-overruled-dot-gen436)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule33] ) ) ) ?gen366 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen369 ) ( negative-overruled $?gen370 & : ( subseq-pos ( create$ rule33-overruled $?gen369 $$$ $?gen370 ) ) ) ) ( test ( eq ( class ?gen366 ) crime_art152_2 ) ) ( not ( and ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen372 & : ( >= ?gen372 1 ) ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen374 & : ( >= ?gen374 1 ) ) ) ?gen366 <- ( crime_art152_2 ( positive-defeated $?gen368 & : ( not ( member$ rule33 $?gen368 ) ) ) ) ) ) => ( calc ( bind $?gen371 ( delete-member$ $?gen370 ( create$ rule33-overruled $?gen369 ) ) ) ) ?gen366 <- ( crime_art152_2 ( negative-overruled $?gen371 ) )"))

([rule33-overruled] of derived-attribute-rule
   (pos-name rule33-overruled-gen438)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule33] ) ) ) ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen372 & : ( >= ?gen372 1 ) ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen374 & : ( >= ?gen374 1 ) ) ) ?gen366 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen369 ) ( negative-overruled $?gen370 & : ( not ( subseq-pos ( create$ rule33-overruled $?gen369 $$$ $?gen370 ) ) ) ) ( positive-defeated $?gen368 & : ( not ( member$ rule33 $?gen368 ) ) ) ) ( test ( eq ( class ?gen366 ) crime_art152_2 ) ) => ( calc ( bind $?gen371 ( create$ rule33-overruled $?gen369 $?gen370 ) ) ) ?gen366 <- ( crime_art152_2 ( negative-overruled $?gen371 ) )"))

([rule33-support] of derived-attribute-rule
   (pos-name rule33-support-gen440)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule33] ) ) ) ?gen364 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ?gen366 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen368 & : ( not ( subseq-pos ( create$ rule33 ?gen364 ?gen365 $$$ $?gen368 ) ) ) ) ) ( test ( eq ( class ?gen366 ) crime_art152_2 ) ) => ( calc ( bind $?gen371 ( create$ rule33 ?gen364 ?gen365 $?gen368 ) ) ) ?gen366 <- ( crime_art152_2 ( positive-support $?gen371 ) )"))

([rule32-defeasibly-dot] of derived-attribute-rule
   (pos-name rule32-defeasibly-dot-gen442)
   (depends-on declare crime_art150 lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule32] ) ) ) ?gen356 <- ( crime_art150 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule32 $? ) ) ( test ( eq ( class ?gen356 ) crime_art150 ) ) ( not ( and ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ( positive ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen356 <- ( crime_art150 ( negative ~ 2 ) ( positive-overruled $?gen358 & : ( not ( member$ rule32 $?gen358 ) ) ) ) ) ) => ?gen356 <- ( crime_art150 ( positive 0 ) )"))

([rule32-defeasibly] of derived-attribute-rule
   (pos-name rule32-defeasibly-gen444)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule32] ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ( positive ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen356 <- ( crime_art150 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen358 & : ( not ( member$ rule32 $?gen358 ) ) ) ) ( test ( eq ( class ?gen356 ) crime_art150 ) ) => ?gen356 <- ( crime_art150 ( positive 1 ) ( positive-derivator rule32 ?gen363 ) )"))

([rule32-overruled-dot] of derived-attribute-rule
   (pos-name rule32-overruled-dot-gen446)
   (depends-on declare crime_art150 lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule32] ) ) ) ?gen356 <- ( crime_art150 ( defendant ?Defendant ) ( negative-support $?gen359 ) ( negative-overruled $?gen360 & : ( subseq-pos ( create$ rule32-overruled $?gen359 $$$ $?gen360 ) ) ) ) ( test ( eq ( class ?gen356 ) crime_art150 ) ) ( not ( and ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ( positive ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen356 <- ( crime_art150 ( positive-defeated $?gen358 & : ( not ( member$ rule32 $?gen358 ) ) ) ) ) ) => ( calc ( bind $?gen361 ( delete-member$ $?gen360 ( create$ rule32-overruled $?gen359 ) ) ) ) ?gen356 <- ( crime_art150 ( negative-overruled $?gen361 ) )"))

([rule32-overruled] of derived-attribute-rule
   (pos-name rule32-overruled-gen448)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule32] ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ( positive ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen356 <- ( crime_art150 ( defendant ?Defendant ) ( negative-support $?gen359 ) ( negative-overruled $?gen360 & : ( not ( subseq-pos ( create$ rule32-overruled $?gen359 $$$ $?gen360 ) ) ) ) ( positive-defeated $?gen358 & : ( not ( member$ rule32 $?gen358 ) ) ) ) ( test ( eq ( class ?gen356 ) crime_art150 ) ) => ( calc ( bind $?gen361 ( create$ rule32-overruled $?gen359 $?gen360 ) ) ) ?gen356 <- ( crime_art150 ( negative-overruled $?gen361 ) )"))

([rule32-support] of derived-attribute-rule
   (pos-name rule32-support-gen450)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule32] ) ) ) ?gen355 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ) ?gen356 <- ( crime_art150 ( defendant ?Defendant ) ( positive-support $?gen358 & : ( not ( subseq-pos ( create$ rule32 ?gen355 $$$ $?gen358 ) ) ) ) ) ( test ( eq ( class ?gen356 ) crime_art150 ) ) => ( calc ( bind $?gen361 ( create$ rule32 ?gen355 $?gen358 ) ) ) ?gen356 <- ( crime_art150 ( positive-support $?gen361 ) )"))

([rule31-defeasibly-dot] of derived-attribute-rule
   (pos-name rule31-defeasibly-dot-gen452)
   (depends-on declare crime_art157 lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule31] ) ) ) ?gen343 <- ( crime_art157 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule31 $? ) ) ( test ( eq ( class ?gen343 ) crime_art157 ) ) ( not ( and ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen349 & : ( >= ?gen349 1 ) ) ) ?gen352 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen351 & : ( >= ?gen351 1 ) ) ) ?gen354 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen353 & : ( >= ?gen353 1 ) ) ) ?gen343 <- ( crime_art157 ( negative ~ 2 ) ( positive-overruled $?gen345 & : ( not ( member$ rule31 $?gen345 ) ) ) ) ) ) => ?gen343 <- ( crime_art157 ( positive 0 ) )"))

([rule31-defeasibly] of derived-attribute-rule
   (pos-name rule31-defeasibly-gen454)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule31] ) ) ) ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen349 & : ( >= ?gen349 1 ) ) ) ?gen352 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen351 & : ( >= ?gen351 1 ) ) ) ?gen354 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen353 & : ( >= ?gen353 1 ) ) ) ?gen343 <- ( crime_art157 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen345 & : ( not ( member$ rule31 $?gen345 ) ) ) ) ( test ( eq ( class ?gen343 ) crime_art157 ) ) => ?gen343 <- ( crime_art157 ( positive 1 ) ( positive-derivator rule31 ?gen350 ?gen352 ?gen354 ) )"))

([rule31-overruled-dot] of derived-attribute-rule
   (pos-name rule31-overruled-dot-gen456)
   (depends-on declare crime_art157 lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule31] ) ) ) ?gen343 <- ( crime_art157 ( defendant ?Defendant ) ( negative-support $?gen346 ) ( negative-overruled $?gen347 & : ( subseq-pos ( create$ rule31-overruled $?gen346 $$$ $?gen347 ) ) ) ) ( test ( eq ( class ?gen343 ) crime_art157 ) ) ( not ( and ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen349 & : ( >= ?gen349 1 ) ) ) ?gen352 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen351 & : ( >= ?gen351 1 ) ) ) ?gen354 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen353 & : ( >= ?gen353 1 ) ) ) ?gen343 <- ( crime_art157 ( positive-defeated $?gen345 & : ( not ( member$ rule31 $?gen345 ) ) ) ) ) ) => ( calc ( bind $?gen348 ( delete-member$ $?gen347 ( create$ rule31-overruled $?gen346 ) ) ) ) ?gen343 <- ( crime_art157 ( negative-overruled $?gen348 ) )"))

([rule31-overruled] of derived-attribute-rule
   (pos-name rule31-overruled-gen458)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule31] ) ) ) ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen349 & : ( >= ?gen349 1 ) ) ) ?gen352 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen351 & : ( >= ?gen351 1 ) ) ) ?gen354 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen353 & : ( >= ?gen353 1 ) ) ) ?gen343 <- ( crime_art157 ( defendant ?Defendant ) ( negative-support $?gen346 ) ( negative-overruled $?gen347 & : ( not ( subseq-pos ( create$ rule31-overruled $?gen346 $$$ $?gen347 ) ) ) ) ( positive-defeated $?gen345 & : ( not ( member$ rule31 $?gen345 ) ) ) ) ( test ( eq ( class ?gen343 ) crime_art157 ) ) => ( calc ( bind $?gen348 ( create$ rule31-overruled $?gen346 $?gen347 ) ) ) ?gen343 <- ( crime_art157 ( negative-overruled $?gen348 ) )"))

([rule31-support] of derived-attribute-rule
   (pos-name rule31-support-gen460)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule31] ) ) ) ?gen340 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen341 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen342 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen343 <- ( crime_art157 ( defendant ?Defendant ) ( positive-support $?gen345 & : ( not ( subseq-pos ( create$ rule31 ?gen340 ?gen341 ?gen342 $$$ $?gen345 ) ) ) ) ) ( test ( eq ( class ?gen343 ) crime_art157 ) ) => ( calc ( bind $?gen348 ( create$ rule31 ?gen340 ?gen341 ?gen342 $?gen345 ) ) ) ?gen343 <- ( crime_art157 ( positive-support $?gen348 ) )"))

([rule30-defeasibly-dot] of derived-attribute-rule
   (pos-name rule30-defeasibly-dot-gen462)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule30] ) ) ) ?gen330 <- ( crime_art156 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule30 $? ) ) ( test ( eq ( class ?gen330 ) crime_art156 ) ) ( not ( and ?gen337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen336 & : ( >= ?gen336 1 ) ) ) ?gen339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen338 & : ( >= ?gen338 1 ) ) ) ?gen330 <- ( crime_art156 ( negative ~ 2 ) ( positive-overruled $?gen332 & : ( not ( member$ rule30 $?gen332 ) ) ) ) ) ) => ?gen330 <- ( crime_art156 ( positive 0 ) )"))

([rule30-defeasibly] of derived-attribute-rule
   (pos-name rule30-defeasibly-gen464)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule30] ) ) ) ?gen337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen336 & : ( >= ?gen336 1 ) ) ) ?gen339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen338 & : ( >= ?gen338 1 ) ) ) ?gen330 <- ( crime_art156 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen332 & : ( not ( member$ rule30 $?gen332 ) ) ) ) ( test ( eq ( class ?gen330 ) crime_art156 ) ) => ?gen330 <- ( crime_art156 ( positive 1 ) ( positive-derivator rule30 ?gen337 ?gen339 ) )"))

([rule30-overruled-dot] of derived-attribute-rule
   (pos-name rule30-overruled-dot-gen466)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule30] ) ) ) ?gen330 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen333 ) ( negative-overruled $?gen334 & : ( subseq-pos ( create$ rule30-overruled $?gen333 $$$ $?gen334 ) ) ) ) ( test ( eq ( class ?gen330 ) crime_art156 ) ) ( not ( and ?gen337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen336 & : ( >= ?gen336 1 ) ) ) ?gen339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen338 & : ( >= ?gen338 1 ) ) ) ?gen330 <- ( crime_art156 ( positive-defeated $?gen332 & : ( not ( member$ rule30 $?gen332 ) ) ) ) ) ) => ( calc ( bind $?gen335 ( delete-member$ $?gen334 ( create$ rule30-overruled $?gen333 ) ) ) ) ?gen330 <- ( crime_art156 ( negative-overruled $?gen335 ) )"))

([rule30-overruled] of derived-attribute-rule
   (pos-name rule30-overruled-gen468)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule30] ) ) ) ?gen337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen336 & : ( >= ?gen336 1 ) ) ) ?gen339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen338 & : ( >= ?gen338 1 ) ) ) ?gen330 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen333 ) ( negative-overruled $?gen334 & : ( not ( subseq-pos ( create$ rule30-overruled $?gen333 $$$ $?gen334 ) ) ) ) ( positive-defeated $?gen332 & : ( not ( member$ rule30 $?gen332 ) ) ) ) ( test ( eq ( class ?gen330 ) crime_art156 ) ) => ( calc ( bind $?gen335 ( create$ rule30-overruled $?gen333 $?gen334 ) ) ) ?gen330 <- ( crime_art156 ( negative-overruled $?gen335 ) )"))

([rule30-support] of derived-attribute-rule
   (pos-name rule30-support-gen470)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule30] ) ) ) ?gen328 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen330 <- ( crime_art156 ( defendant ?Defendant ) ( positive-support $?gen332 & : ( not ( subseq-pos ( create$ rule30 ?gen328 ?gen329 $$$ $?gen332 ) ) ) ) ) ( test ( eq ( class ?gen330 ) crime_art156 ) ) => ( calc ( bind $?gen335 ( create$ rule30 ?gen328 ?gen329 $?gen332 ) ) ) ?gen330 <- ( crime_art156 ( positive-support $?gen335 ) )"))

([rule29-defeasibly-dot] of derived-attribute-rule
   (pos-name rule29-defeasibly-dot-gen472)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule29] ) ) ) ?gen318 <- ( crime_art156 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule29 $? ) ) ( test ( eq ( class ?gen318 ) crime_art156 ) ) ( not ( and ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen318 <- ( crime_art156 ( negative ~ 2 ) ( positive-overruled $?gen320 & : ( not ( member$ rule29 $?gen320 ) ) ) ) ) ) => ?gen318 <- ( crime_art156 ( positive 0 ) )"))

([rule29-defeasibly] of derived-attribute-rule
   (pos-name rule29-defeasibly-gen474)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule29] ) ) ) ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen318 <- ( crime_art156 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen320 & : ( not ( member$ rule29 $?gen320 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art156 ) ) => ?gen318 <- ( crime_art156 ( positive 1 ) ( positive-derivator rule29 ?gen325 ?gen327 ) )"))

([rule29-overruled-dot] of derived-attribute-rule
   (pos-name rule29-overruled-dot-gen476)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule29] ) ) ) ?gen318 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen321 ) ( negative-overruled $?gen322 & : ( subseq-pos ( create$ rule29-overruled $?gen321 $$$ $?gen322 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art156 ) ) ( not ( and ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen318 <- ( crime_art156 ( positive-defeated $?gen320 & : ( not ( member$ rule29 $?gen320 ) ) ) ) ) ) => ( calc ( bind $?gen323 ( delete-member$ $?gen322 ( create$ rule29-overruled $?gen321 ) ) ) ) ?gen318 <- ( crime_art156 ( negative-overruled $?gen323 ) )"))

([rule29-overruled] of derived-attribute-rule
   (pos-name rule29-overruled-gen478)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule29] ) ) ) ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen318 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen321 ) ( negative-overruled $?gen322 & : ( not ( subseq-pos ( create$ rule29-overruled $?gen321 $$$ $?gen322 ) ) ) ) ( positive-defeated $?gen320 & : ( not ( member$ rule29 $?gen320 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art156 ) ) => ( calc ( bind $?gen323 ( create$ rule29-overruled $?gen321 $?gen322 ) ) ) ?gen318 <- ( crime_art156 ( negative-overruled $?gen323 ) )"))

([rule29-support] of derived-attribute-rule
   (pos-name rule29-support-gen480)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule29] ) ) ) ?gen316 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen317 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen318 <- ( crime_art156 ( defendant ?Defendant ) ( positive-support $?gen320 & : ( not ( subseq-pos ( create$ rule29 ?gen316 ?gen317 $$$ $?gen320 ) ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art156 ) ) => ( calc ( bind $?gen323 ( create$ rule29 ?gen316 ?gen317 $?gen320 ) ) ) ?gen318 <- ( crime_art156 ( positive-support $?gen323 ) )"))

([rule28-defeasibly-dot] of derived-attribute-rule
   (pos-name rule28-defeasibly-dot-gen482)
   (depends-on declare crime_art151b lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule28] ) ) ) ?gen308 <- ( crime_art151b ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule28 $? ) ) ( test ( eq ( class ?gen308 ) crime_art151b ) ) ( not ( and ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen314 & : ( >= ?gen314 1 ) ) ) ?gen308 <- ( crime_art151b ( negative ~ 2 ) ( positive-overruled $?gen310 & : ( not ( member$ rule28 $?gen310 ) ) ) ) ) ) => ?gen308 <- ( crime_art151b ( positive 0 ) )"))

([rule28-defeasibly] of derived-attribute-rule
   (pos-name rule28-defeasibly-gen484)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule28] ) ) ) ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen314 & : ( >= ?gen314 1 ) ) ) ?gen308 <- ( crime_art151b ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen310 & : ( not ( member$ rule28 $?gen310 ) ) ) ) ( test ( eq ( class ?gen308 ) crime_art151b ) ) => ?gen308 <- ( crime_art151b ( positive 1 ) ( positive-derivator rule28 ?gen315 ) )"))

([rule28-overruled-dot] of derived-attribute-rule
   (pos-name rule28-overruled-dot-gen486)
   (depends-on declare crime_art151b lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule28] ) ) ) ?gen308 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen311 ) ( negative-overruled $?gen312 & : ( subseq-pos ( create$ rule28-overruled $?gen311 $$$ $?gen312 ) ) ) ) ( test ( eq ( class ?gen308 ) crime_art151b ) ) ( not ( and ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen314 & : ( >= ?gen314 1 ) ) ) ?gen308 <- ( crime_art151b ( positive-defeated $?gen310 & : ( not ( member$ rule28 $?gen310 ) ) ) ) ) ) => ( calc ( bind $?gen313 ( delete-member$ $?gen312 ( create$ rule28-overruled $?gen311 ) ) ) ) ?gen308 <- ( crime_art151b ( negative-overruled $?gen313 ) )"))

([rule28-overruled] of derived-attribute-rule
   (pos-name rule28-overruled-gen488)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule28] ) ) ) ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen314 & : ( >= ?gen314 1 ) ) ) ?gen308 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen311 ) ( negative-overruled $?gen312 & : ( not ( subseq-pos ( create$ rule28-overruled $?gen311 $$$ $?gen312 ) ) ) ) ( positive-defeated $?gen310 & : ( not ( member$ rule28 $?gen310 ) ) ) ) ( test ( eq ( class ?gen308 ) crime_art151b ) ) => ( calc ( bind $?gen313 ( create$ rule28-overruled $?gen311 $?gen312 ) ) ) ?gen308 <- ( crime_art151b ( negative-overruled $?gen313 ) )"))

([rule28-support] of derived-attribute-rule
   (pos-name rule28-support-gen490)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule28] ) ) ) ?gen307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ?gen308 <- ( crime_art151b ( defendant ?Defendant ) ( positive-support $?gen310 & : ( not ( subseq-pos ( create$ rule28 ?gen307 $$$ $?gen310 ) ) ) ) ) ( test ( eq ( class ?gen308 ) crime_art151b ) ) => ( calc ( bind $?gen313 ( create$ rule28 ?gen307 $?gen310 ) ) ) ?gen308 <- ( crime_art151b ( positive-support $?gen313 ) )"))

([rule27-defeasibly-dot] of derived-attribute-rule
   (pos-name rule27-defeasibly-dot-gen492)
   (depends-on declare crime_art151b lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule27] ) ) ) ?gen299 <- ( crime_art151b ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule27 $? ) ) ( test ( eq ( class ?gen299 ) crime_art151b ) ) ( not ( and ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen299 <- ( crime_art151b ( negative ~ 2 ) ( positive-overruled $?gen301 & : ( not ( member$ rule27 $?gen301 ) ) ) ) ) ) => ?gen299 <- ( crime_art151b ( positive 0 ) )"))

([rule27-defeasibly] of derived-attribute-rule
   (pos-name rule27-defeasibly-gen494)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule27] ) ) ) ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen299 <- ( crime_art151b ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen301 & : ( not ( member$ rule27 $?gen301 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art151b ) ) => ?gen299 <- ( crime_art151b ( positive 1 ) ( positive-derivator rule27 ?gen306 ) )"))

([rule27-overruled-dot] of derived-attribute-rule
   (pos-name rule27-overruled-dot-gen496)
   (depends-on declare crime_art151b lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule27] ) ) ) ?gen299 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen302 ) ( negative-overruled $?gen303 & : ( subseq-pos ( create$ rule27-overruled $?gen302 $$$ $?gen303 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art151b ) ) ( not ( and ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen299 <- ( crime_art151b ( positive-defeated $?gen301 & : ( not ( member$ rule27 $?gen301 ) ) ) ) ) ) => ( calc ( bind $?gen304 ( delete-member$ $?gen303 ( create$ rule27-overruled $?gen302 ) ) ) ) ?gen299 <- ( crime_art151b ( negative-overruled $?gen304 ) )"))

([rule27-overruled] of derived-attribute-rule
   (pos-name rule27-overruled-gen498)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule27] ) ) ) ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen299 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen302 ) ( negative-overruled $?gen303 & : ( not ( subseq-pos ( create$ rule27-overruled $?gen302 $$$ $?gen303 ) ) ) ) ( positive-defeated $?gen301 & : ( not ( member$ rule27 $?gen301 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art151b ) ) => ( calc ( bind $?gen304 ( create$ rule27-overruled $?gen302 $?gen303 ) ) ) ?gen299 <- ( crime_art151b ( negative-overruled $?gen304 ) )"))

([rule27-support] of derived-attribute-rule
   (pos-name rule27-support-gen500)
   (depends-on declare lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule27] ) ) ) ?gen298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ?gen299 <- ( crime_art151b ( defendant ?Defendant ) ( positive-support $?gen301 & : ( not ( subseq-pos ( create$ rule27 ?gen298 $$$ $?gen301 ) ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art151b ) ) => ( calc ( bind $?gen304 ( create$ rule27 ?gen298 $?gen301 ) ) ) ?gen299 <- ( crime_art151b ( positive-support $?gen304 ) )"))

([rule26-defeasibly-dot] of derived-attribute-rule
   (pos-name rule26-defeasibly-dot-gen502)
   (depends-on declare crime_art151a lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule26] ) ) ) ?gen290 <- ( crime_art151a ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule26 $? ) ) ( test ( eq ( class ?gen290 ) crime_art151a ) ) ( not ( and ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen296 & : ( >= ?gen296 1 ) ) ) ?gen290 <- ( crime_art151a ( negative ~ 2 ) ( positive-overruled $?gen292 & : ( not ( member$ rule26 $?gen292 ) ) ) ) ) ) => ?gen290 <- ( crime_art151a ( positive 0 ) )"))

([rule26-defeasibly] of derived-attribute-rule
   (pos-name rule26-defeasibly-gen504)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule26] ) ) ) ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen296 & : ( >= ?gen296 1 ) ) ) ?gen290 <- ( crime_art151a ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen292 & : ( not ( member$ rule26 $?gen292 ) ) ) ) ( test ( eq ( class ?gen290 ) crime_art151a ) ) => ?gen290 <- ( crime_art151a ( positive 1 ) ( positive-derivator rule26 ?gen297 ) )"))

([rule26-overruled-dot] of derived-attribute-rule
   (pos-name rule26-overruled-dot-gen506)
   (depends-on declare crime_art151a lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule26] ) ) ) ?gen290 <- ( crime_art151a ( defendant ?Defendant ) ( negative-support $?gen293 ) ( negative-overruled $?gen294 & : ( subseq-pos ( create$ rule26-overruled $?gen293 $$$ $?gen294 ) ) ) ) ( test ( eq ( class ?gen290 ) crime_art151a ) ) ( not ( and ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen296 & : ( >= ?gen296 1 ) ) ) ?gen290 <- ( crime_art151a ( positive-defeated $?gen292 & : ( not ( member$ rule26 $?gen292 ) ) ) ) ) ) => ( calc ( bind $?gen295 ( delete-member$ $?gen294 ( create$ rule26-overruled $?gen293 ) ) ) ) ?gen290 <- ( crime_art151a ( negative-overruled $?gen295 ) )"))

([rule26-overruled] of derived-attribute-rule
   (pos-name rule26-overruled-gen508)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule26] ) ) ) ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen296 & : ( >= ?gen296 1 ) ) ) ?gen290 <- ( crime_art151a ( defendant ?Defendant ) ( negative-support $?gen293 ) ( negative-overruled $?gen294 & : ( not ( subseq-pos ( create$ rule26-overruled $?gen293 $$$ $?gen294 ) ) ) ) ( positive-defeated $?gen292 & : ( not ( member$ rule26 $?gen292 ) ) ) ) ( test ( eq ( class ?gen290 ) crime_art151a ) ) => ( calc ( bind $?gen295 ( create$ rule26-overruled $?gen293 $?gen294 ) ) ) ?gen290 <- ( crime_art151a ( negative-overruled $?gen295 ) )"))

([rule26-support] of derived-attribute-rule
   (pos-name rule26-support-gen510)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule26] ) ) ) ?gen289 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ?gen290 <- ( crime_art151a ( defendant ?Defendant ) ( positive-support $?gen292 & : ( not ( subseq-pos ( create$ rule26 ?gen289 $$$ $?gen292 ) ) ) ) ) ( test ( eq ( class ?gen290 ) crime_art151a ) ) => ( calc ( bind $?gen295 ( create$ rule26 ?gen289 $?gen292 ) ) ) ?gen290 <- ( crime_art151a ( positive-support $?gen295 ) )"))

([rule25-defeasibly-dot] of derived-attribute-rule
   (pos-name rule25-defeasibly-dot-gen512)
   (depends-on declare crime_art150 lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule25] ) ) ) ?gen281 <- ( crime_art150 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule25 $? ) ) ( test ( eq ( class ?gen281 ) crime_art150 ) ) ( not ( and ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen281 <- ( crime_art150 ( negative ~ 2 ) ( positive-overruled $?gen283 & : ( not ( member$ rule25 $?gen283 ) ) ) ) ) ) => ?gen281 <- ( crime_art150 ( positive 0 ) )"))

([rule25-defeasibly] of derived-attribute-rule
   (pos-name rule25-defeasibly-gen514)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule25] ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen281 <- ( crime_art150 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen283 & : ( not ( member$ rule25 $?gen283 ) ) ) ) ( test ( eq ( class ?gen281 ) crime_art150 ) ) => ?gen281 <- ( crime_art150 ( positive 1 ) ( positive-derivator rule25 ?gen288 ) )"))

([rule25-overruled-dot] of derived-attribute-rule
   (pos-name rule25-overruled-dot-gen516)
   (depends-on declare crime_art150 lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule25] ) ) ) ?gen281 <- ( crime_art150 ( defendant ?Defendant ) ( negative-support $?gen284 ) ( negative-overruled $?gen285 & : ( subseq-pos ( create$ rule25-overruled $?gen284 $$$ $?gen285 ) ) ) ) ( test ( eq ( class ?gen281 ) crime_art150 ) ) ( not ( and ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen281 <- ( crime_art150 ( positive-defeated $?gen283 & : ( not ( member$ rule25 $?gen283 ) ) ) ) ) ) => ( calc ( bind $?gen286 ( delete-member$ $?gen285 ( create$ rule25-overruled $?gen284 ) ) ) ) ?gen281 <- ( crime_art150 ( negative-overruled $?gen286 ) )"))

([rule25-overruled] of derived-attribute-rule
   (pos-name rule25-overruled-gen518)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule25] ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen281 <- ( crime_art150 ( defendant ?Defendant ) ( negative-support $?gen284 ) ( negative-overruled $?gen285 & : ( not ( subseq-pos ( create$ rule25-overruled $?gen284 $$$ $?gen285 ) ) ) ) ( positive-defeated $?gen283 & : ( not ( member$ rule25 $?gen283 ) ) ) ) ( test ( eq ( class ?gen281 ) crime_art150 ) ) => ( calc ( bind $?gen286 ( create$ rule25-overruled $?gen284 $?gen285 ) ) ) ?gen281 <- ( crime_art150 ( negative-overruled $?gen286 ) )"))

([rule25-support] of derived-attribute-rule
   (pos-name rule25-support-gen520)
   (depends-on declare lc:case crime_art150)
   (implies crime_art150)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule25] ) ) ) ?gen280 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen281 <- ( crime_art150 ( defendant ?Defendant ) ( positive-support $?gen283 & : ( not ( subseq-pos ( create$ rule25 ?gen280 $$$ $?gen283 ) ) ) ) ) ( test ( eq ( class ?gen281 ) crime_art150 ) ) => ( calc ( bind $?gen286 ( create$ rule25 ?gen280 $?gen283 ) ) ) ?gen281 <- ( crime_art150 ( positive-support $?gen286 ) )"))

([rule24-defeasibly-dot] of derived-attribute-rule
   (pos-name rule24-defeasibly-dot-gen522)
   (depends-on declare crime_art149_5 lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule24] ) ) ) ?gen270 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule24 $? ) ) ( test ( eq ( class ?gen270 ) crime_art149_5 ) ) ( not ( and ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen276 & : ( >= ?gen276 1 ) ) ) ?gen279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen278 & : ( >= ?gen278 1 ) ) ) ?gen270 <- ( crime_art149_5 ( negative ~ 2 ) ( positive-overruled $?gen272 & : ( not ( member$ rule24 $?gen272 ) ) ) ) ) ) => ?gen270 <- ( crime_art149_5 ( positive 0 ) )"))

([rule24-defeasibly] of derived-attribute-rule
   (pos-name rule24-defeasibly-gen524)
   (depends-on declare lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule24] ) ) ) ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen276 & : ( >= ?gen276 1 ) ) ) ?gen279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen278 & : ( >= ?gen278 1 ) ) ) ?gen270 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen272 & : ( not ( member$ rule24 $?gen272 ) ) ) ) ( test ( eq ( class ?gen270 ) crime_art149_5 ) ) => ?gen270 <- ( crime_art149_5 ( positive 1 ) ( positive-derivator rule24 ?gen277 ?gen279 ) )"))

([rule24-overruled-dot] of derived-attribute-rule
   (pos-name rule24-overruled-dot-gen526)
   (depends-on declare crime_art149_5 lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule24] ) ) ) ?gen270 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen273 ) ( negative-overruled $?gen274 & : ( subseq-pos ( create$ rule24-overruled $?gen273 $$$ $?gen274 ) ) ) ) ( test ( eq ( class ?gen270 ) crime_art149_5 ) ) ( not ( and ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen276 & : ( >= ?gen276 1 ) ) ) ?gen279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen278 & : ( >= ?gen278 1 ) ) ) ?gen270 <- ( crime_art149_5 ( positive-defeated $?gen272 & : ( not ( member$ rule24 $?gen272 ) ) ) ) ) ) => ( calc ( bind $?gen275 ( delete-member$ $?gen274 ( create$ rule24-overruled $?gen273 ) ) ) ) ?gen270 <- ( crime_art149_5 ( negative-overruled $?gen275 ) )"))

([rule24-overruled] of derived-attribute-rule
   (pos-name rule24-overruled-gen528)
   (depends-on declare lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule24] ) ) ) ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen276 & : ( >= ?gen276 1 ) ) ) ?gen279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen278 & : ( >= ?gen278 1 ) ) ) ?gen270 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen273 ) ( negative-overruled $?gen274 & : ( not ( subseq-pos ( create$ rule24-overruled $?gen273 $$$ $?gen274 ) ) ) ) ( positive-defeated $?gen272 & : ( not ( member$ rule24 $?gen272 ) ) ) ) ( test ( eq ( class ?gen270 ) crime_art149_5 ) ) => ( calc ( bind $?gen275 ( create$ rule24-overruled $?gen273 $?gen274 ) ) ) ?gen270 <- ( crime_art149_5 ( negative-overruled $?gen275 ) )"))

([rule24-support] of derived-attribute-rule
   (pos-name rule24-support-gen530)
   (depends-on declare lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule24] ) ) ) ?gen268 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ?gen270 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive-support $?gen272 & : ( not ( subseq-pos ( create$ rule24 ?gen268 ?gen269 $$$ $?gen272 ) ) ) ) ) ( test ( eq ( class ?gen270 ) crime_art149_5 ) ) => ( calc ( bind $?gen275 ( create$ rule24 ?gen268 ?gen269 $?gen272 ) ) ) ?gen270 <- ( crime_art149_5 ( positive-support $?gen275 ) )"))

([rule23-defeasibly-dot] of derived-attribute-rule
   (pos-name rule23-defeasibly-dot-gen532)
   (depends-on declare crime_art149_2 lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule23] ) ) ) ?gen258 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule23 $? ) ) ( test ( eq ( class ?gen258 ) crime_art149_2 ) ) ( not ( and ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen258 <- ( crime_art149_2 ( negative ~ 2 ) ( positive-overruled $?gen260 & : ( not ( member$ rule23 $?gen260 ) ) ) ) ) ) => ?gen258 <- ( crime_art149_2 ( positive 0 ) )"))

([rule23-defeasibly] of derived-attribute-rule
   (pos-name rule23-defeasibly-gen534)
   (depends-on declare lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule23] ) ) ) ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen258 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen260 & : ( not ( member$ rule23 $?gen260 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art149_2 ) ) => ?gen258 <- ( crime_art149_2 ( positive 1 ) ( positive-derivator rule23 ?gen265 ?gen267 ) )"))

([rule23-overruled-dot] of derived-attribute-rule
   (pos-name rule23-overruled-dot-gen536)
   (depends-on declare crime_art149_2 lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule23] ) ) ) ?gen258 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen261 ) ( negative-overruled $?gen262 & : ( subseq-pos ( create$ rule23-overruled $?gen261 $$$ $?gen262 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art149_2 ) ) ( not ( and ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen258 <- ( crime_art149_2 ( positive-defeated $?gen260 & : ( not ( member$ rule23 $?gen260 ) ) ) ) ) ) => ( calc ( bind $?gen263 ( delete-member$ $?gen262 ( create$ rule23-overruled $?gen261 ) ) ) ) ?gen258 <- ( crime_art149_2 ( negative-overruled $?gen263 ) )"))

([rule23-overruled] of derived-attribute-rule
   (pos-name rule23-overruled-gen538)
   (depends-on declare lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule23] ) ) ) ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen258 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen261 ) ( negative-overruled $?gen262 & : ( not ( subseq-pos ( create$ rule23-overruled $?gen261 $$$ $?gen262 ) ) ) ) ( positive-defeated $?gen260 & : ( not ( member$ rule23 $?gen260 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art149_2 ) ) => ( calc ( bind $?gen263 ( create$ rule23-overruled $?gen261 $?gen262 ) ) ) ?gen258 <- ( crime_art149_2 ( negative-overruled $?gen263 ) )"))

([rule23-support] of derived-attribute-rule
   (pos-name rule23-support-gen540)
   (depends-on declare lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule23] ) ) ) ?gen256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen258 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive-support $?gen260 & : ( not ( subseq-pos ( create$ rule23 ?gen256 ?gen257 $$$ $?gen260 ) ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art149_2 ) ) => ( calc ( bind $?gen263 ( create$ rule23 ?gen256 ?gen257 $?gen260 ) ) ) ?gen258 <- ( crime_art149_2 ( positive-support $?gen263 ) )"))

([rule22-defeasibly-dot] of derived-attribute-rule
   (pos-name rule22-defeasibly-dot-gen542)
   (depends-on declare crime_art149_1 lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule22] ) ) ) ?gen246 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule22 $? ) ) ( test ( eq ( class ?gen246 ) crime_art149_1 ) ) ( not ( and ?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen252 & : ( >= ?gen252 1 ) ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen254 & : ( >= ?gen254 1 ) ) ) ?gen246 <- ( crime_art149_1 ( negative ~ 2 ) ( positive-overruled $?gen248 & : ( not ( member$ rule22 $?gen248 ) ) ) ) ) ) => ?gen246 <- ( crime_art149_1 ( positive 0 ) )"))

([rule22-defeasibly] of derived-attribute-rule
   (pos-name rule22-defeasibly-gen544)
   (depends-on declare lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule22] ) ) ) ?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen252 & : ( >= ?gen252 1 ) ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen254 & : ( >= ?gen254 1 ) ) ) ?gen246 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen248 & : ( not ( member$ rule22 $?gen248 ) ) ) ) ( test ( eq ( class ?gen246 ) crime_art149_1 ) ) => ?gen246 <- ( crime_art149_1 ( positive 1 ) ( positive-derivator rule22 ?gen253 ?gen255 ) )"))

([rule22-overruled-dot] of derived-attribute-rule
   (pos-name rule22-overruled-dot-gen546)
   (depends-on declare crime_art149_1 lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule22] ) ) ) ?gen246 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen249 ) ( negative-overruled $?gen250 & : ( subseq-pos ( create$ rule22-overruled $?gen249 $$$ $?gen250 ) ) ) ) ( test ( eq ( class ?gen246 ) crime_art149_1 ) ) ( not ( and ?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen252 & : ( >= ?gen252 1 ) ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen254 & : ( >= ?gen254 1 ) ) ) ?gen246 <- ( crime_art149_1 ( positive-defeated $?gen248 & : ( not ( member$ rule22 $?gen248 ) ) ) ) ) ) => ( calc ( bind $?gen251 ( delete-member$ $?gen250 ( create$ rule22-overruled $?gen249 ) ) ) ) ?gen246 <- ( crime_art149_1 ( negative-overruled $?gen251 ) )"))

([rule22-overruled] of derived-attribute-rule
   (pos-name rule22-overruled-gen548)
   (depends-on declare lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule22] ) ) ) ?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen252 & : ( >= ?gen252 1 ) ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen254 & : ( >= ?gen254 1 ) ) ) ?gen246 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen249 ) ( negative-overruled $?gen250 & : ( not ( subseq-pos ( create$ rule22-overruled $?gen249 $$$ $?gen250 ) ) ) ) ( positive-defeated $?gen248 & : ( not ( member$ rule22 $?gen248 ) ) ) ) ( test ( eq ( class ?gen246 ) crime_art149_1 ) ) => ( calc ( bind $?gen251 ( create$ rule22-overruled $?gen249 $?gen250 ) ) ) ?gen246 <- ( crime_art149_1 ( negative-overruled $?gen251 ) )"))

([rule22-support] of derived-attribute-rule
   (pos-name rule22-support-gen550)
   (depends-on declare lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule22] ) ) ) ?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen245 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen246 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive-support $?gen248 & : ( not ( subseq-pos ( create$ rule22 ?gen244 ?gen245 $$$ $?gen248 ) ) ) ) ) ( test ( eq ( class ?gen246 ) crime_art149_1 ) ) => ( calc ( bind $?gen251 ( create$ rule22 ?gen244 ?gen245 $?gen248 ) ) ) ?gen246 <- ( crime_art149_1 ( positive-support $?gen251 ) )"))

([rule21-defeasibly-dot] of derived-attribute-rule
   (pos-name rule21-defeasibly-dot-gen552)
   (depends-on declare crime_art148 lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule21] ) ) ) ?gen234 <- ( crime_art148 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule21 $? ) ) ( test ( eq ( class ?gen234 ) crime_art148 ) ) ( not ( and ?gen241 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen240 & : ( >= ?gen240 1 ) ) ) ?gen243 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen242 & : ( >= ?gen242 1 ) ) ) ?gen234 <- ( crime_art148 ( negative ~ 2 ) ( positive-overruled $?gen236 & : ( not ( member$ rule21 $?gen236 ) ) ) ) ) ) => ?gen234 <- ( crime_art148 ( positive 0 ) )"))

([rule21-defeasibly] of derived-attribute-rule
   (pos-name rule21-defeasibly-gen554)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule21] ) ) ) ?gen241 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen240 & : ( >= ?gen240 1 ) ) ) ?gen243 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen242 & : ( >= ?gen242 1 ) ) ) ?gen234 <- ( crime_art148 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen236 & : ( not ( member$ rule21 $?gen236 ) ) ) ) ( test ( eq ( class ?gen234 ) crime_art148 ) ) => ?gen234 <- ( crime_art148 ( positive 1 ) ( positive-derivator rule21 ?gen241 ?gen243 ) )"))

([rule21-overruled-dot] of derived-attribute-rule
   (pos-name rule21-overruled-dot-gen556)
   (depends-on declare crime_art148 lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule21] ) ) ) ?gen234 <- ( crime_art148 ( defendant ?Defendant ) ( negative-support $?gen237 ) ( negative-overruled $?gen238 & : ( subseq-pos ( create$ rule21-overruled $?gen237 $$$ $?gen238 ) ) ) ) ( test ( eq ( class ?gen234 ) crime_art148 ) ) ( not ( and ?gen241 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen240 & : ( >= ?gen240 1 ) ) ) ?gen243 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen242 & : ( >= ?gen242 1 ) ) ) ?gen234 <- ( crime_art148 ( positive-defeated $?gen236 & : ( not ( member$ rule21 $?gen236 ) ) ) ) ) ) => ( calc ( bind $?gen239 ( delete-member$ $?gen238 ( create$ rule21-overruled $?gen237 ) ) ) ) ?gen234 <- ( crime_art148 ( negative-overruled $?gen239 ) )"))

([rule21-overruled] of derived-attribute-rule
   (pos-name rule21-overruled-gen558)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule21] ) ) ) ?gen241 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen240 & : ( >= ?gen240 1 ) ) ) ?gen243 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen242 & : ( >= ?gen242 1 ) ) ) ?gen234 <- ( crime_art148 ( defendant ?Defendant ) ( negative-support $?gen237 ) ( negative-overruled $?gen238 & : ( not ( subseq-pos ( create$ rule21-overruled $?gen237 $$$ $?gen238 ) ) ) ) ( positive-defeated $?gen236 & : ( not ( member$ rule21 $?gen236 ) ) ) ) ( test ( eq ( class ?gen234 ) crime_art148 ) ) => ( calc ( bind $?gen239 ( create$ rule21-overruled $?gen237 $?gen238 ) ) ) ?gen234 <- ( crime_art148 ( negative-overruled $?gen239 ) )"))

([rule21-support] of derived-attribute-rule
   (pos-name rule21-support-gen560)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule21] ) ) ) ?gen232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ?gen234 <- ( crime_art148 ( defendant ?Defendant ) ( positive-support $?gen236 & : ( not ( subseq-pos ( create$ rule21 ?gen232 ?gen233 $$$ $?gen236 ) ) ) ) ) ( test ( eq ( class ?gen234 ) crime_art148 ) ) => ( calc ( bind $?gen239 ( create$ rule21 ?gen232 ?gen233 $?gen236 ) ) ) ?gen234 <- ( crime_art148 ( positive-support $?gen239 ) )"))

([rule20-defeasibly-dot] of derived-attribute-rule
   (pos-name rule20-defeasibly-dot-gen562)
   (depends-on declare crime_art147 lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule20] ) ) ) ?gen222 <- ( crime_art147 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule20 $? ) ) ( test ( eq ( class ?gen222 ) crime_art147 ) ) ( not ( and ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen222 <- ( crime_art147 ( negative ~ 2 ) ( positive-overruled $?gen224 & : ( not ( member$ rule20 $?gen224 ) ) ) ) ) ) => ?gen222 <- ( crime_art147 ( positive 0 ) )"))

([rule20-defeasibly] of derived-attribute-rule
   (pos-name rule20-defeasibly-gen564)
   (depends-on declare lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule20] ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen222 <- ( crime_art147 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen224 & : ( not ( member$ rule20 $?gen224 ) ) ) ) ( test ( eq ( class ?gen222 ) crime_art147 ) ) => ?gen222 <- ( crime_art147 ( positive 1 ) ( positive-derivator rule20 ?gen229 ?gen231 ) )"))

([rule20-overruled-dot] of derived-attribute-rule
   (pos-name rule20-overruled-dot-gen566)
   (depends-on declare crime_art147 lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule20] ) ) ) ?gen222 <- ( crime_art147 ( defendant ?Defendant ) ( negative-support $?gen225 ) ( negative-overruled $?gen226 & : ( subseq-pos ( create$ rule20-overruled $?gen225 $$$ $?gen226 ) ) ) ) ( test ( eq ( class ?gen222 ) crime_art147 ) ) ( not ( and ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen222 <- ( crime_art147 ( positive-defeated $?gen224 & : ( not ( member$ rule20 $?gen224 ) ) ) ) ) ) => ( calc ( bind $?gen227 ( delete-member$ $?gen226 ( create$ rule20-overruled $?gen225 ) ) ) ) ?gen222 <- ( crime_art147 ( negative-overruled $?gen227 ) )"))

([rule20-overruled] of derived-attribute-rule
   (pos-name rule20-overruled-gen568)
   (depends-on declare lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule20] ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen222 <- ( crime_art147 ( defendant ?Defendant ) ( negative-support $?gen225 ) ( negative-overruled $?gen226 & : ( not ( subseq-pos ( create$ rule20-overruled $?gen225 $$$ $?gen226 ) ) ) ) ( positive-defeated $?gen224 & : ( not ( member$ rule20 $?gen224 ) ) ) ) ( test ( eq ( class ?gen222 ) crime_art147 ) ) => ( calc ( bind $?gen227 ( create$ rule20-overruled $?gen225 $?gen226 ) ) ) ?gen222 <- ( crime_art147 ( negative-overruled $?gen227 ) )"))

([rule20-support] of derived-attribute-rule
   (pos-name rule20-support-gen570)
   (depends-on declare lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule20] ) ) ) ?gen220 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen222 <- ( crime_art147 ( defendant ?Defendant ) ( positive-support $?gen224 & : ( not ( subseq-pos ( create$ rule20 ?gen220 ?gen221 $$$ $?gen224 ) ) ) ) ) ( test ( eq ( class ?gen222 ) crime_art147 ) ) => ( calc ( bind $?gen227 ( create$ rule20 ?gen220 ?gen221 $?gen224 ) ) ) ?gen222 <- ( crime_art147 ( positive-support $?gen227 ) )"))

([rule19-defeasibly-dot] of derived-attribute-rule
   (pos-name rule19-defeasibly-dot-gen572)
   (depends-on declare crime_art146 lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule19] ) ) ) ?gen210 <- ( crime_art146 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule19 $? ) ) ( test ( eq ( class ?gen210 ) crime_art146 ) ) ( not ( and ?gen217 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen216 & : ( >= ?gen216 1 ) ) ) ?gen219 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen218 & : ( >= ?gen218 1 ) ) ) ?gen210 <- ( crime_art146 ( negative ~ 2 ) ( positive-overruled $?gen212 & : ( not ( member$ rule19 $?gen212 ) ) ) ) ) ) => ?gen210 <- ( crime_art146 ( positive 0 ) )"))

([rule19-defeasibly] of derived-attribute-rule
   (pos-name rule19-defeasibly-gen574)
   (depends-on declare lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule19] ) ) ) ?gen217 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen216 & : ( >= ?gen216 1 ) ) ) ?gen219 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen218 & : ( >= ?gen218 1 ) ) ) ?gen210 <- ( crime_art146 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen212 & : ( not ( member$ rule19 $?gen212 ) ) ) ) ( test ( eq ( class ?gen210 ) crime_art146 ) ) => ?gen210 <- ( crime_art146 ( positive 1 ) ( positive-derivator rule19 ?gen217 ?gen219 ) )"))

([rule19-overruled-dot] of derived-attribute-rule
   (pos-name rule19-overruled-dot-gen576)
   (depends-on declare crime_art146 lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule19] ) ) ) ?gen210 <- ( crime_art146 ( defendant ?Defendant ) ( negative-support $?gen213 ) ( negative-overruled $?gen214 & : ( subseq-pos ( create$ rule19-overruled $?gen213 $$$ $?gen214 ) ) ) ) ( test ( eq ( class ?gen210 ) crime_art146 ) ) ( not ( and ?gen217 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen216 & : ( >= ?gen216 1 ) ) ) ?gen219 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen218 & : ( >= ?gen218 1 ) ) ) ?gen210 <- ( crime_art146 ( positive-defeated $?gen212 & : ( not ( member$ rule19 $?gen212 ) ) ) ) ) ) => ( calc ( bind $?gen215 ( delete-member$ $?gen214 ( create$ rule19-overruled $?gen213 ) ) ) ) ?gen210 <- ( crime_art146 ( negative-overruled $?gen215 ) )"))

([rule19-overruled] of derived-attribute-rule
   (pos-name rule19-overruled-gen578)
   (depends-on declare lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule19] ) ) ) ?gen217 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen216 & : ( >= ?gen216 1 ) ) ) ?gen219 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen218 & : ( >= ?gen218 1 ) ) ) ?gen210 <- ( crime_art146 ( defendant ?Defendant ) ( negative-support $?gen213 ) ( negative-overruled $?gen214 & : ( not ( subseq-pos ( create$ rule19-overruled $?gen213 $$$ $?gen214 ) ) ) ) ( positive-defeated $?gen212 & : ( not ( member$ rule19 $?gen212 ) ) ) ) ( test ( eq ( class ?gen210 ) crime_art146 ) ) => ( calc ( bind $?gen215 ( create$ rule19-overruled $?gen213 $?gen214 ) ) ) ?gen210 <- ( crime_art146 ( negative-overruled $?gen215 ) )"))

([rule19-support] of derived-attribute-rule
   (pos-name rule19-support-gen580)
   (depends-on declare lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule19] ) ) ) ?gen208 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ?gen210 <- ( crime_art146 ( defendant ?Defendant ) ( positive-support $?gen212 & : ( not ( subseq-pos ( create$ rule19 ?gen208 ?gen209 $$$ $?gen212 ) ) ) ) ) ( test ( eq ( class ?gen210 ) crime_art146 ) ) => ( calc ( bind $?gen215 ( create$ rule19 ?gen208 ?gen209 $?gen212 ) ) ) ?gen210 <- ( crime_art146 ( positive-support $?gen215 ) )"))

([rule18-defeasibly-dot] of derived-attribute-rule
   (pos-name rule18-defeasibly-dot-gen582)
   (depends-on declare crime_art145 lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule18] ) ) ) ?gen198 <- ( crime_art145 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule18 $? ) ) ( test ( eq ( class ?gen198 ) crime_art145 ) ) ( not ( and ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen198 <- ( crime_art145 ( negative ~ 2 ) ( positive-overruled $?gen200 & : ( not ( member$ rule18 $?gen200 ) ) ) ) ) ) => ?gen198 <- ( crime_art145 ( positive 0 ) )"))

([rule18-defeasibly] of derived-attribute-rule
   (pos-name rule18-defeasibly-gen584)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule18] ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen198 <- ( crime_art145 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen200 & : ( not ( member$ rule18 $?gen200 ) ) ) ) ( test ( eq ( class ?gen198 ) crime_art145 ) ) => ?gen198 <- ( crime_art145 ( positive 1 ) ( positive-derivator rule18 ?gen205 ?gen207 ) )"))

([rule18-overruled-dot] of derived-attribute-rule
   (pos-name rule18-overruled-dot-gen586)
   (depends-on declare crime_art145 lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule18] ) ) ) ?gen198 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen201 ) ( negative-overruled $?gen202 & : ( subseq-pos ( create$ rule18-overruled $?gen201 $$$ $?gen202 ) ) ) ) ( test ( eq ( class ?gen198 ) crime_art145 ) ) ( not ( and ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen198 <- ( crime_art145 ( positive-defeated $?gen200 & : ( not ( member$ rule18 $?gen200 ) ) ) ) ) ) => ( calc ( bind $?gen203 ( delete-member$ $?gen202 ( create$ rule18-overruled $?gen201 ) ) ) ) ?gen198 <- ( crime_art145 ( negative-overruled $?gen203 ) )"))

([rule18-overruled] of derived-attribute-rule
   (pos-name rule18-overruled-gen588)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule18] ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen198 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen201 ) ( negative-overruled $?gen202 & : ( not ( subseq-pos ( create$ rule18-overruled $?gen201 $$$ $?gen202 ) ) ) ) ( positive-defeated $?gen200 & : ( not ( member$ rule18 $?gen200 ) ) ) ) ( test ( eq ( class ?gen198 ) crime_art145 ) ) => ( calc ( bind $?gen203 ( create$ rule18-overruled $?gen201 $?gen202 ) ) ) ?gen198 <- ( crime_art145 ( negative-overruled $?gen203 ) )"))

([rule18-support] of derived-attribute-rule
   (pos-name rule18-support-gen590)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule18] ) ) ) ?gen196 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen197 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ) ?gen198 <- ( crime_art145 ( defendant ?Defendant ) ( positive-support $?gen200 & : ( not ( subseq-pos ( create$ rule18 ?gen196 ?gen197 $$$ $?gen200 ) ) ) ) ) ( test ( eq ( class ?gen198 ) crime_art145 ) ) => ( calc ( bind $?gen203 ( create$ rule18 ?gen196 ?gen197 $?gen200 ) ) ) ?gen198 <- ( crime_art145 ( positive-support $?gen203 ) )"))

([rule17-defeasibly-dot] of derived-attribute-rule
   (pos-name rule17-defeasibly-dot-gen592)
   (depends-on declare crime_art145 lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule17] ) ) ) ?gen186 <- ( crime_art145 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule17 $? ) ) ( test ( eq ( class ?gen186 ) crime_art145 ) ) ( not ( and ?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen192 & : ( >= ?gen192 1 ) ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen194 & : ( >= ?gen194 1 ) ) ) ?gen186 <- ( crime_art145 ( negative ~ 2 ) ( positive-overruled $?gen188 & : ( not ( member$ rule17 $?gen188 ) ) ) ) ) ) => ?gen186 <- ( crime_art145 ( positive 0 ) )"))

([rule17-defeasibly] of derived-attribute-rule
   (pos-name rule17-defeasibly-gen594)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule17] ) ) ) ?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen192 & : ( >= ?gen192 1 ) ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen194 & : ( >= ?gen194 1 ) ) ) ?gen186 <- ( crime_art145 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen188 & : ( not ( member$ rule17 $?gen188 ) ) ) ) ( test ( eq ( class ?gen186 ) crime_art145 ) ) => ?gen186 <- ( crime_art145 ( positive 1 ) ( positive-derivator rule17 ?gen193 ?gen195 ) )"))

([rule17-overruled-dot] of derived-attribute-rule
   (pos-name rule17-overruled-dot-gen596)
   (depends-on declare crime_art145 lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule17] ) ) ) ?gen186 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen189 ) ( negative-overruled $?gen190 & : ( subseq-pos ( create$ rule17-overruled $?gen189 $$$ $?gen190 ) ) ) ) ( test ( eq ( class ?gen186 ) crime_art145 ) ) ( not ( and ?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen192 & : ( >= ?gen192 1 ) ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen194 & : ( >= ?gen194 1 ) ) ) ?gen186 <- ( crime_art145 ( positive-defeated $?gen188 & : ( not ( member$ rule17 $?gen188 ) ) ) ) ) ) => ( calc ( bind $?gen191 ( delete-member$ $?gen190 ( create$ rule17-overruled $?gen189 ) ) ) ) ?gen186 <- ( crime_art145 ( negative-overruled $?gen191 ) )"))

([rule17-overruled] of derived-attribute-rule
   (pos-name rule17-overruled-gen598)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule17] ) ) ) ?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen192 & : ( >= ?gen192 1 ) ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen194 & : ( >= ?gen194 1 ) ) ) ?gen186 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen189 ) ( negative-overruled $?gen190 & : ( not ( subseq-pos ( create$ rule17-overruled $?gen189 $$$ $?gen190 ) ) ) ) ( positive-defeated $?gen188 & : ( not ( member$ rule17 $?gen188 ) ) ) ) ( test ( eq ( class ?gen186 ) crime_art145 ) ) => ( calc ( bind $?gen191 ( create$ rule17-overruled $?gen189 $?gen190 ) ) ) ?gen186 <- ( crime_art145 ( negative-overruled $?gen191 ) )"))

([rule17-support] of derived-attribute-rule
   (pos-name rule17-support-gen600)
   (depends-on declare lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule17] ) ) ) ?gen184 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen185 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen186 <- ( crime_art145 ( defendant ?Defendant ) ( positive-support $?gen188 & : ( not ( subseq-pos ( create$ rule17 ?gen184 ?gen185 $$$ $?gen188 ) ) ) ) ) ( test ( eq ( class ?gen186 ) crime_art145 ) ) => ( calc ( bind $?gen191 ( create$ rule17 ?gen184 ?gen185 $?gen188 ) ) ) ?gen186 <- ( crime_art145 ( positive-support $?gen191 ) )"))

([rule16-defeasibly-dot] of derived-attribute-rule
   (pos-name rule16-defeasibly-dot-gen602)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule16] ) ) ) ?gen174 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule16 $? ) ) ( test ( eq ( class ?gen174 ) crime_art144 ) ) ( not ( and ?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen180 & : ( >= ?gen180 1 ) ) ) ?gen183 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen182 & : ( >= ?gen182 1 ) ) ) ?gen174 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen176 & : ( not ( member$ rule16 $?gen176 ) ) ) ) ) ) => ?gen174 <- ( crime_art144 ( positive 0 ) )"))

([rule16-defeasibly] of derived-attribute-rule
   (pos-name rule16-defeasibly-gen604)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule16] ) ) ) ?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen180 & : ( >= ?gen180 1 ) ) ) ?gen183 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen182 & : ( >= ?gen182 1 ) ) ) ?gen174 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen176 & : ( not ( member$ rule16 $?gen176 ) ) ) ) ( test ( eq ( class ?gen174 ) crime_art144 ) ) => ?gen174 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule16 ?gen181 ?gen183 ) )"))

([rule16-overruled-dot] of derived-attribute-rule
   (pos-name rule16-overruled-dot-gen606)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule16] ) ) ) ?gen174 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen177 ) ( negative-overruled $?gen178 & : ( subseq-pos ( create$ rule16-overruled $?gen177 $$$ $?gen178 ) ) ) ) ( test ( eq ( class ?gen174 ) crime_art144 ) ) ( not ( and ?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen180 & : ( >= ?gen180 1 ) ) ) ?gen183 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen182 & : ( >= ?gen182 1 ) ) ) ?gen174 <- ( crime_art144 ( positive-defeated $?gen176 & : ( not ( member$ rule16 $?gen176 ) ) ) ) ) ) => ( calc ( bind $?gen179 ( delete-member$ $?gen178 ( create$ rule16-overruled $?gen177 ) ) ) ) ?gen174 <- ( crime_art144 ( negative-overruled $?gen179 ) )"))

([rule16-overruled] of derived-attribute-rule
   (pos-name rule16-overruled-gen608)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule16] ) ) ) ?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen180 & : ( >= ?gen180 1 ) ) ) ?gen183 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen182 & : ( >= ?gen182 1 ) ) ) ?gen174 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen177 ) ( negative-overruled $?gen178 & : ( not ( subseq-pos ( create$ rule16-overruled $?gen177 $$$ $?gen178 ) ) ) ) ( positive-defeated $?gen176 & : ( not ( member$ rule16 $?gen176 ) ) ) ) ( test ( eq ( class ?gen174 ) crime_art144 ) ) => ( calc ( bind $?gen179 ( create$ rule16-overruled $?gen177 $?gen178 ) ) ) ?gen174 <- ( crime_art144 ( negative-overruled $?gen179 ) )"))

([rule16-support] of derived-attribute-rule
   (pos-name rule16-support-gen610)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule16] ) ) ) ?gen172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen173 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ?gen174 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen176 & : ( not ( subseq-pos ( create$ rule16 ?gen172 ?gen173 $$$ $?gen176 ) ) ) ) ) ( test ( eq ( class ?gen174 ) crime_art144 ) ) => ( calc ( bind $?gen179 ( create$ rule16 ?gen172 ?gen173 $?gen176 ) ) ) ?gen174 <- ( crime_art144 ( positive-support $?gen179 ) )"))

([rule15-defeasibly-dot] of derived-attribute-rule
   (pos-name rule15-defeasibly-dot-gen612)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule15] ) ) ) ?gen162 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule15 $? ) ) ( test ( eq ( class ?gen162 ) crime_art144 ) ) ( not ( and ?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen168 & : ( >= ?gen168 1 ) ) ) ?gen171 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen170 & : ( >= ?gen170 1 ) ) ) ?gen162 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen164 & : ( not ( member$ rule15 $?gen164 ) ) ) ) ) ) => ?gen162 <- ( crime_art144 ( positive 0 ) )"))

([rule15-defeasibly] of derived-attribute-rule
   (pos-name rule15-defeasibly-gen614)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule15] ) ) ) ?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen168 & : ( >= ?gen168 1 ) ) ) ?gen171 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen170 & : ( >= ?gen170 1 ) ) ) ?gen162 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen164 & : ( not ( member$ rule15 $?gen164 ) ) ) ) ( test ( eq ( class ?gen162 ) crime_art144 ) ) => ?gen162 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule15 ?gen169 ?gen171 ) )"))

([rule15-overruled-dot] of derived-attribute-rule
   (pos-name rule15-overruled-dot-gen616)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule15] ) ) ) ?gen162 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen165 ) ( negative-overruled $?gen166 & : ( subseq-pos ( create$ rule15-overruled $?gen165 $$$ $?gen166 ) ) ) ) ( test ( eq ( class ?gen162 ) crime_art144 ) ) ( not ( and ?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen168 & : ( >= ?gen168 1 ) ) ) ?gen171 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen170 & : ( >= ?gen170 1 ) ) ) ?gen162 <- ( crime_art144 ( positive-defeated $?gen164 & : ( not ( member$ rule15 $?gen164 ) ) ) ) ) ) => ( calc ( bind $?gen167 ( delete-member$ $?gen166 ( create$ rule15-overruled $?gen165 ) ) ) ) ?gen162 <- ( crime_art144 ( negative-overruled $?gen167 ) )"))

([rule15-overruled] of derived-attribute-rule
   (pos-name rule15-overruled-gen618)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule15] ) ) ) ?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen168 & : ( >= ?gen168 1 ) ) ) ?gen171 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen170 & : ( >= ?gen170 1 ) ) ) ?gen162 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen165 ) ( negative-overruled $?gen166 & : ( not ( subseq-pos ( create$ rule15-overruled $?gen165 $$$ $?gen166 ) ) ) ) ( positive-defeated $?gen164 & : ( not ( member$ rule15 $?gen164 ) ) ) ) ( test ( eq ( class ?gen162 ) crime_art144 ) ) => ( calc ( bind $?gen167 ( create$ rule15-overruled $?gen165 $?gen166 ) ) ) ?gen162 <- ( crime_art144 ( negative-overruled $?gen167 ) )"))

([rule15-support] of derived-attribute-rule
   (pos-name rule15-support-gen620)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule15] ) ) ) ?gen160 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ?gen162 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen164 & : ( not ( subseq-pos ( create$ rule15 ?gen160 ?gen161 $$$ $?gen164 ) ) ) ) ) ( test ( eq ( class ?gen162 ) crime_art144 ) ) => ( calc ( bind $?gen167 ( create$ rule15 ?gen160 ?gen161 $?gen164 ) ) ) ?gen162 <- ( crime_art144 ( positive-support $?gen167 ) )"))

([rule14-defeasibly-dot] of derived-attribute-rule
   (pos-name rule14-defeasibly-dot-gen622)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule14] ) ) ) ?gen150 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule14 $? ) ) ( test ( eq ( class ?gen150 ) crime_art144 ) ) ( not ( and ?gen157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen156 & : ( >= ?gen156 1 ) ) ) ?gen159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen158 & : ( >= ?gen158 1 ) ) ) ?gen150 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen152 & : ( not ( member$ rule14 $?gen152 ) ) ) ) ) ) => ?gen150 <- ( crime_art144 ( positive 0 ) )"))

([rule14-defeasibly] of derived-attribute-rule
   (pos-name rule14-defeasibly-gen624)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule14] ) ) ) ?gen157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen156 & : ( >= ?gen156 1 ) ) ) ?gen159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen158 & : ( >= ?gen158 1 ) ) ) ?gen150 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen152 & : ( not ( member$ rule14 $?gen152 ) ) ) ) ( test ( eq ( class ?gen150 ) crime_art144 ) ) => ?gen150 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule14 ?gen157 ?gen159 ) )"))

([rule14-overruled-dot] of derived-attribute-rule
   (pos-name rule14-overruled-dot-gen626)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule14] ) ) ) ?gen150 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen153 ) ( negative-overruled $?gen154 & : ( subseq-pos ( create$ rule14-overruled $?gen153 $$$ $?gen154 ) ) ) ) ( test ( eq ( class ?gen150 ) crime_art144 ) ) ( not ( and ?gen157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen156 & : ( >= ?gen156 1 ) ) ) ?gen159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen158 & : ( >= ?gen158 1 ) ) ) ?gen150 <- ( crime_art144 ( positive-defeated $?gen152 & : ( not ( member$ rule14 $?gen152 ) ) ) ) ) ) => ( calc ( bind $?gen155 ( delete-member$ $?gen154 ( create$ rule14-overruled $?gen153 ) ) ) ) ?gen150 <- ( crime_art144 ( negative-overruled $?gen155 ) )"))

([rule14-overruled] of derived-attribute-rule
   (pos-name rule14-overruled-gen628)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule14] ) ) ) ?gen157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen156 & : ( >= ?gen156 1 ) ) ) ?gen159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen158 & : ( >= ?gen158 1 ) ) ) ?gen150 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen153 ) ( negative-overruled $?gen154 & : ( not ( subseq-pos ( create$ rule14-overruled $?gen153 $$$ $?gen154 ) ) ) ) ( positive-defeated $?gen152 & : ( not ( member$ rule14 $?gen152 ) ) ) ) ( test ( eq ( class ?gen150 ) crime_art144 ) ) => ( calc ( bind $?gen155 ( create$ rule14-overruled $?gen153 $?gen154 ) ) ) ?gen150 <- ( crime_art144 ( negative-overruled $?gen155 ) )"))

([rule14-support] of derived-attribute-rule
   (pos-name rule14-support-gen630)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule14] ) ) ) ?gen148 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ?gen150 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen152 & : ( not ( subseq-pos ( create$ rule14 ?gen148 ?gen149 $$$ $?gen152 ) ) ) ) ) ( test ( eq ( class ?gen150 ) crime_art144 ) ) => ( calc ( bind $?gen155 ( create$ rule14 ?gen148 ?gen149 $?gen152 ) ) ) ?gen150 <- ( crime_art144 ( positive-support $?gen155 ) )"))

([rule13-defeasibly-dot] of derived-attribute-rule
   (pos-name rule13-defeasibly-dot-gen632)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule13] ) ) ) ?gen138 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule13 $? ) ) ( test ( eq ( class ?gen138 ) crime_art144 ) ) ( not ( and ?gen145 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen144 & : ( >= ?gen144 1 ) ) ) ?gen147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen146 & : ( >= ?gen146 1 ) ) ) ?gen138 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen140 & : ( not ( member$ rule13 $?gen140 ) ) ) ) ) ) => ?gen138 <- ( crime_art144 ( positive 0 ) )"))

([rule13-defeasibly] of derived-attribute-rule
   (pos-name rule13-defeasibly-gen634)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule13] ) ) ) ?gen145 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen144 & : ( >= ?gen144 1 ) ) ) ?gen147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen146 & : ( >= ?gen146 1 ) ) ) ?gen138 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen140 & : ( not ( member$ rule13 $?gen140 ) ) ) ) ( test ( eq ( class ?gen138 ) crime_art144 ) ) => ?gen138 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule13 ?gen145 ?gen147 ) )"))

([rule13-overruled-dot] of derived-attribute-rule
   (pos-name rule13-overruled-dot-gen636)
   (depends-on declare crime_art144 lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule13] ) ) ) ?gen138 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen141 ) ( negative-overruled $?gen142 & : ( subseq-pos ( create$ rule13-overruled $?gen141 $$$ $?gen142 ) ) ) ) ( test ( eq ( class ?gen138 ) crime_art144 ) ) ( not ( and ?gen145 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen144 & : ( >= ?gen144 1 ) ) ) ?gen147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen146 & : ( >= ?gen146 1 ) ) ) ?gen138 <- ( crime_art144 ( positive-defeated $?gen140 & : ( not ( member$ rule13 $?gen140 ) ) ) ) ) ) => ( calc ( bind $?gen143 ( delete-member$ $?gen142 ( create$ rule13-overruled $?gen141 ) ) ) ) ?gen138 <- ( crime_art144 ( negative-overruled $?gen143 ) )"))

([rule13-overruled] of derived-attribute-rule
   (pos-name rule13-overruled-gen638)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule13] ) ) ) ?gen145 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen144 & : ( >= ?gen144 1 ) ) ) ?gen147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen146 & : ( >= ?gen146 1 ) ) ) ?gen138 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen141 ) ( negative-overruled $?gen142 & : ( not ( subseq-pos ( create$ rule13-overruled $?gen141 $$$ $?gen142 ) ) ) ) ( positive-defeated $?gen140 & : ( not ( member$ rule13 $?gen140 ) ) ) ) ( test ( eq ( class ?gen138 ) crime_art144 ) ) => ( calc ( bind $?gen143 ( create$ rule13-overruled $?gen141 $?gen142 ) ) ) ?gen138 <- ( crime_art144 ( negative-overruled $?gen143 ) )"))

([rule13-support] of derived-attribute-rule
   (pos-name rule13-support-gen640)
   (depends-on declare lc:case lc:case crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule13] ) ) ) ?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen137 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen138 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen140 & : ( not ( subseq-pos ( create$ rule13 ?gen136 ?gen137 $$$ $?gen140 ) ) ) ) ) ( test ( eq ( class ?gen138 ) crime_art144 ) ) => ( calc ( bind $?gen143 ( create$ rule13 ?gen136 ?gen137 $?gen140 ) ) ) ?gen138 <- ( crime_art144 ( positive-support $?gen143 ) )"))

([rule12-defeasibly-dot] of derived-attribute-rule
   (pos-name rule12-defeasibly-dot-gen642)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule12] ) ) ) ?gen126 <- ( crime_art143 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule12 $? ) ) ( test ( eq ( class ?gen126 ) crime_art143 ) ) ( not ( and ?gen133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen132 & : ( >= ?gen132 1 ) ) ) ?gen135 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen134 & : ( >= ?gen134 1 ) ) ) ?gen126 <- ( crime_art143 ( negative ~ 2 ) ( positive-overruled $?gen128 & : ( not ( member$ rule12 $?gen128 ) ) ) ) ) ) => ?gen126 <- ( crime_art143 ( positive 0 ) )"))

([rule12-defeasibly] of derived-attribute-rule
   (pos-name rule12-defeasibly-gen644)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule12] ) ) ) ?gen133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen132 & : ( >= ?gen132 1 ) ) ) ?gen135 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen134 & : ( >= ?gen134 1 ) ) ) ?gen126 <- ( crime_art143 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen128 & : ( not ( member$ rule12 $?gen128 ) ) ) ) ( test ( eq ( class ?gen126 ) crime_art143 ) ) => ?gen126 <- ( crime_art143 ( positive 1 ) ( positive-derivator rule12 ?gen133 ?gen135 ) )"))

([rule12-overruled-dot] of derived-attribute-rule
   (pos-name rule12-overruled-dot-gen646)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule12] ) ) ) ?gen126 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen129 ) ( negative-overruled $?gen130 & : ( subseq-pos ( create$ rule12-overruled $?gen129 $$$ $?gen130 ) ) ) ) ( test ( eq ( class ?gen126 ) crime_art143 ) ) ( not ( and ?gen133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen132 & : ( >= ?gen132 1 ) ) ) ?gen135 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen134 & : ( >= ?gen134 1 ) ) ) ?gen126 <- ( crime_art143 ( positive-defeated $?gen128 & : ( not ( member$ rule12 $?gen128 ) ) ) ) ) ) => ( calc ( bind $?gen131 ( delete-member$ $?gen130 ( create$ rule12-overruled $?gen129 ) ) ) ) ?gen126 <- ( crime_art143 ( negative-overruled $?gen131 ) )"))

([rule12-overruled] of derived-attribute-rule
   (pos-name rule12-overruled-gen648)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule12] ) ) ) ?gen133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen132 & : ( >= ?gen132 1 ) ) ) ?gen135 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen134 & : ( >= ?gen134 1 ) ) ) ?gen126 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen129 ) ( negative-overruled $?gen130 & : ( not ( subseq-pos ( create$ rule12-overruled $?gen129 $$$ $?gen130 ) ) ) ) ( positive-defeated $?gen128 & : ( not ( member$ rule12 $?gen128 ) ) ) ) ( test ( eq ( class ?gen126 ) crime_art143 ) ) => ( calc ( bind $?gen131 ( create$ rule12-overruled $?gen129 $?gen130 ) ) ) ?gen126 <- ( crime_art143 ( negative-overruled $?gen131 ) )"))

([rule12-support] of derived-attribute-rule
   (pos-name rule12-support-gen650)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule12] ) ) ) ?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen125 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ?gen126 <- ( crime_art143 ( defendant ?Defendant ) ( positive-support $?gen128 & : ( not ( subseq-pos ( create$ rule12 ?gen124 ?gen125 $$$ $?gen128 ) ) ) ) ) ( test ( eq ( class ?gen126 ) crime_art143 ) ) => ( calc ( bind $?gen131 ( create$ rule12 ?gen124 ?gen125 $?gen128 ) ) ) ?gen126 <- ( crime_art143 ( positive-support $?gen131 ) )"))

([rule11-defeasibly-dot] of derived-attribute-rule
   (pos-name rule11-defeasibly-dot-gen652)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule11] ) ) ) ?gen114 <- ( crime_art143 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule11 $? ) ) ( test ( eq ( class ?gen114 ) crime_art143 ) ) ( not ( and ?gen121 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen120 & : ( >= ?gen120 1 ) ) ) ?gen123 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen122 & : ( >= ?gen122 1 ) ) ) ?gen114 <- ( crime_art143 ( negative ~ 2 ) ( positive-overruled $?gen116 & : ( not ( member$ rule11 $?gen116 ) ) ) ) ) ) => ?gen114 <- ( crime_art143 ( positive 0 ) )"))

([rule11-defeasibly] of derived-attribute-rule
   (pos-name rule11-defeasibly-gen654)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule11] ) ) ) ?gen121 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen120 & : ( >= ?gen120 1 ) ) ) ?gen123 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen122 & : ( >= ?gen122 1 ) ) ) ?gen114 <- ( crime_art143 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen116 & : ( not ( member$ rule11 $?gen116 ) ) ) ) ( test ( eq ( class ?gen114 ) crime_art143 ) ) => ?gen114 <- ( crime_art143 ( positive 1 ) ( positive-derivator rule11 ?gen121 ?gen123 ) )"))

([rule11-overruled-dot] of derived-attribute-rule
   (pos-name rule11-overruled-dot-gen656)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule11] ) ) ) ?gen114 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen117 ) ( negative-overruled $?gen118 & : ( subseq-pos ( create$ rule11-overruled $?gen117 $$$ $?gen118 ) ) ) ) ( test ( eq ( class ?gen114 ) crime_art143 ) ) ( not ( and ?gen121 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen120 & : ( >= ?gen120 1 ) ) ) ?gen123 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen122 & : ( >= ?gen122 1 ) ) ) ?gen114 <- ( crime_art143 ( positive-defeated $?gen116 & : ( not ( member$ rule11 $?gen116 ) ) ) ) ) ) => ( calc ( bind $?gen119 ( delete-member$ $?gen118 ( create$ rule11-overruled $?gen117 ) ) ) ) ?gen114 <- ( crime_art143 ( negative-overruled $?gen119 ) )"))

([rule11-overruled] of derived-attribute-rule
   (pos-name rule11-overruled-gen658)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule11] ) ) ) ?gen121 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen120 & : ( >= ?gen120 1 ) ) ) ?gen123 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen122 & : ( >= ?gen122 1 ) ) ) ?gen114 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen117 ) ( negative-overruled $?gen118 & : ( not ( subseq-pos ( create$ rule11-overruled $?gen117 $$$ $?gen118 ) ) ) ) ( positive-defeated $?gen116 & : ( not ( member$ rule11 $?gen116 ) ) ) ) ( test ( eq ( class ?gen114 ) crime_art143 ) ) => ( calc ( bind $?gen119 ( create$ rule11-overruled $?gen117 $?gen118 ) ) ) ?gen114 <- ( crime_art143 ( negative-overruled $?gen119 ) )"))

([rule11-support] of derived-attribute-rule
   (pos-name rule11-support-gen660)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule11] ) ) ) ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen113 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ?gen114 <- ( crime_art143 ( defendant ?Defendant ) ( positive-support $?gen116 & : ( not ( subseq-pos ( create$ rule11 ?gen112 ?gen113 $$$ $?gen116 ) ) ) ) ) ( test ( eq ( class ?gen114 ) crime_art143 ) ) => ( calc ( bind $?gen119 ( create$ rule11 ?gen112 ?gen113 $?gen116 ) ) ) ?gen114 <- ( crime_art143 ( positive-support $?gen119 ) )"))

([rule10-defeasibly-dot] of derived-attribute-rule
   (pos-name rule10-defeasibly-dot-gen662)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule10] ) ) ) ?gen102 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule10 $? ) ) ( test ( eq ( class ?gen102 ) crime_art155_1 ) ) ( not ( and ?gen109 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen108 & : ( >= ?gen108 1 ) ) ) ?gen111 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen110 & : ( >= ?gen110 1 ) ) ) ?gen102 <- ( crime_art155_1 ( negative ~ 2 ) ( positive-overruled $?gen104 & : ( not ( member$ rule10 $?gen104 ) ) ) ) ) ) => ?gen102 <- ( crime_art155_1 ( positive 0 ) )"))

([rule10-defeasibly] of derived-attribute-rule
   (pos-name rule10-defeasibly-gen664)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule10] ) ) ) ?gen109 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen108 & : ( >= ?gen108 1 ) ) ) ?gen111 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen110 & : ( >= ?gen110 1 ) ) ) ?gen102 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen104 & : ( not ( member$ rule10 $?gen104 ) ) ) ) ( test ( eq ( class ?gen102 ) crime_art155_1 ) ) => ?gen102 <- ( crime_art155_1 ( positive 1 ) ( positive-derivator rule10 ?gen109 ?gen111 ) )"))

([rule10-overruled-dot] of derived-attribute-rule
   (pos-name rule10-overruled-dot-gen666)
   (depends-on declare crime_art155_1 lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule10] ) ) ) ?gen102 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen105 ) ( negative-overruled $?gen106 & : ( subseq-pos ( create$ rule10-overruled $?gen105 $$$ $?gen106 ) ) ) ) ( test ( eq ( class ?gen102 ) crime_art155_1 ) ) ( not ( and ?gen109 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen108 & : ( >= ?gen108 1 ) ) ) ?gen111 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen110 & : ( >= ?gen110 1 ) ) ) ?gen102 <- ( crime_art155_1 ( positive-defeated $?gen104 & : ( not ( member$ rule10 $?gen104 ) ) ) ) ) ) => ( calc ( bind $?gen107 ( delete-member$ $?gen106 ( create$ rule10-overruled $?gen105 ) ) ) ) ?gen102 <- ( crime_art155_1 ( negative-overruled $?gen107 ) )"))

([rule10-overruled] of derived-attribute-rule
   (pos-name rule10-overruled-gen668)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule10] ) ) ) ?gen109 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen108 & : ( >= ?gen108 1 ) ) ) ?gen111 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen110 & : ( >= ?gen110 1 ) ) ) ?gen102 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen105 ) ( negative-overruled $?gen106 & : ( not ( subseq-pos ( create$ rule10-overruled $?gen105 $$$ $?gen106 ) ) ) ) ( positive-defeated $?gen104 & : ( not ( member$ rule10 $?gen104 ) ) ) ) ( test ( eq ( class ?gen102 ) crime_art155_1 ) ) => ( calc ( bind $?gen107 ( create$ rule10-overruled $?gen105 $?gen106 ) ) ) ?gen102 <- ( crime_art155_1 ( negative-overruled $?gen107 ) )"))

([rule10-support] of derived-attribute-rule
   (pos-name rule10-support-gen670)
   (depends-on declare lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule10] ) ) ) ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen101 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen102 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive-support $?gen104 & : ( not ( subseq-pos ( create$ rule10 ?gen100 ?gen101 $$$ $?gen104 ) ) ) ) ) ( test ( eq ( class ?gen102 ) crime_art155_1 ) ) => ( calc ( bind $?gen107 ( create$ rule10 ?gen100 ?gen101 $?gen104 ) ) ) ?gen102 <- ( crime_art155_1 ( positive-support $?gen107 ) )"))

([rule9-defeasibly-dot] of derived-attribute-rule
   (pos-name rule9-defeasibly-dot-gen672)
   (depends-on declare crime_art154 lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule9] ) ) ) ?gen92 <- ( crime_art154 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule9 $? ) ) ( test ( eq ( class ?gen92 ) crime_art154 ) ) ( not ( and ?gen99 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen98 & : ( >= ?gen98 1 ) ) ) ?gen92 <- ( crime_art154 ( negative ~ 2 ) ( positive-overruled $?gen94 & : ( not ( member$ rule9 $?gen94 ) ) ) ) ) ) => ?gen92 <- ( crime_art154 ( positive 0 ) )"))

([rule9-defeasibly] of derived-attribute-rule
   (pos-name rule9-defeasibly-gen674)
   (depends-on declare lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule9] ) ) ) ?gen99 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen98 & : ( >= ?gen98 1 ) ) ) ?gen92 <- ( crime_art154 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen94 & : ( not ( member$ rule9 $?gen94 ) ) ) ) ( test ( eq ( class ?gen92 ) crime_art154 ) ) => ?gen92 <- ( crime_art154 ( positive 1 ) ( positive-derivator rule9 ?gen99 ) )"))

([rule9-overruled-dot] of derived-attribute-rule
   (pos-name rule9-overruled-dot-gen676)
   (depends-on declare crime_art154 lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule9] ) ) ) ?gen92 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen95 ) ( negative-overruled $?gen96 & : ( subseq-pos ( create$ rule9-overruled $?gen95 $$$ $?gen96 ) ) ) ) ( test ( eq ( class ?gen92 ) crime_art154 ) ) ( not ( and ?gen99 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen98 & : ( >= ?gen98 1 ) ) ) ?gen92 <- ( crime_art154 ( positive-defeated $?gen94 & : ( not ( member$ rule9 $?gen94 ) ) ) ) ) ) => ( calc ( bind $?gen97 ( delete-member$ $?gen96 ( create$ rule9-overruled $?gen95 ) ) ) ) ?gen92 <- ( crime_art154 ( negative-overruled $?gen97 ) )"))

([rule9-overruled] of derived-attribute-rule
   (pos-name rule9-overruled-gen678)
   (depends-on declare lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule9] ) ) ) ?gen99 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen98 & : ( >= ?gen98 1 ) ) ) ?gen92 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen95 ) ( negative-overruled $?gen96 & : ( not ( subseq-pos ( create$ rule9-overruled $?gen95 $$$ $?gen96 ) ) ) ) ( positive-defeated $?gen94 & : ( not ( member$ rule9 $?gen94 ) ) ) ) ( test ( eq ( class ?gen92 ) crime_art154 ) ) => ( calc ( bind $?gen97 ( create$ rule9-overruled $?gen95 $?gen96 ) ) ) ?gen92 <- ( crime_art154 ( negative-overruled $?gen97 ) )"))

([rule9-support] of derived-attribute-rule
   (pos-name rule9-support-gen680)
   (depends-on declare lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule9] ) ) ) ?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen92 <- ( crime_art154 ( defendant ?Defendant ) ( positive-support $?gen94 & : ( not ( subseq-pos ( create$ rule9 ?gen91 $$$ $?gen94 ) ) ) ) ) ( test ( eq ( class ?gen92 ) crime_art154 ) ) => ( calc ( bind $?gen97 ( create$ rule9 ?gen91 $?gen94 ) ) ) ?gen92 <- ( crime_art154 ( positive-support $?gen97 ) )"))

([rule8-defeasibly-dot] of derived-attribute-rule
   (pos-name rule8-defeasibly-dot-gen682)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule8] ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule8 $? ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) ( not ( and ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( negative ~ 2 ) ( positive-overruled $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ) ) => ?gen81 <- ( crime_art153 ( positive 0 ) )"))

([rule8-defeasibly] of derived-attribute-rule
   (pos-name rule8-defeasibly-gen684)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule8] ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ?gen81 <- ( crime_art153 ( positive 1 ) ( positive-derivator rule8 ?gen88 ?gen90 ) )"))

([rule8-overruled-dot] of derived-attribute-rule
   (pos-name rule8-overruled-dot-gen686)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule8] ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen84 ) ( negative-overruled $?gen85 & : ( subseq-pos ( create$ rule8-overruled $?gen84 $$$ $?gen85 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) ( not ( and ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( positive-defeated $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ) ) => ( calc ( bind $?gen86 ( delete-member$ $?gen85 ( create$ rule8-overruled $?gen84 ) ) ) ) ?gen81 <- ( crime_art153 ( negative-overruled $?gen86 ) )"))

([rule8-overruled] of derived-attribute-rule
   (pos-name rule8-overruled-gen688)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule8] ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen84 ) ( negative-overruled $?gen85 & : ( not ( subseq-pos ( create$ rule8-overruled $?gen84 $$$ $?gen85 ) ) ) ) ( positive-defeated $?gen83 & : ( not ( member$ rule8 $?gen83 ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ( calc ( bind $?gen86 ( create$ rule8-overruled $?gen84 $?gen85 ) ) ) ?gen81 <- ( crime_art153 ( negative-overruled $?gen86 ) )"))

([rule8-support] of derived-attribute-rule
   (pos-name rule8-support-gen690)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule8] ) ) ) ?gen79 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen80 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ?gen81 <- ( crime_art153 ( defendant ?Defendant ) ( positive-support $?gen83 & : ( not ( subseq-pos ( create$ rule8 ?gen79 ?gen80 $$$ $?gen83 ) ) ) ) ) ( test ( eq ( class ?gen81 ) crime_art153 ) ) => ( calc ( bind $?gen86 ( create$ rule8 ?gen79 ?gen80 $?gen83 ) ) ) ?gen81 <- ( crime_art153 ( positive-support $?gen86 ) )"))

([rule7-defeasibly-dot] of derived-attribute-rule
   (pos-name rule7-defeasibly-dot-gen692)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule7] ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule7 $? ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) ( not ( and ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ) ) => ?gen69 <- ( crime_art152_2 ( positive 0 ) )"))

([rule7-defeasibly] of derived-attribute-rule
   (pos-name rule7-defeasibly-gen694)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule7] ) ) ) ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ?gen69 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule7 ?gen76 ?gen78 ) )"))

([rule7-overruled-dot] of derived-attribute-rule
   (pos-name rule7-overruled-dot-gen696)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule7] ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen72 ) ( negative-overruled $?gen73 & : ( subseq-pos ( create$ rule7-overruled $?gen72 $$$ $?gen73 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) ( not ( and ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( positive-defeated $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ) ) => ( calc ( bind $?gen74 ( delete-member$ $?gen73 ( create$ rule7-overruled $?gen72 ) ) ) ) ?gen69 <- ( crime_art152_2 ( negative-overruled $?gen74 ) )"))

([rule7-overruled] of derived-attribute-rule
   (pos-name rule7-overruled-gen698)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule7] ) ) ) ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen75 & : ( >= ?gen75 1 ) ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen77 & : ( >= ?gen77 1 ) ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen72 ) ( negative-overruled $?gen73 & : ( not ( subseq-pos ( create$ rule7-overruled $?gen72 $$$ $?gen73 ) ) ) ) ( positive-defeated $?gen71 & : ( not ( member$ rule7 $?gen71 ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ( calc ( bind $?gen74 ( create$ rule7-overruled $?gen72 $?gen73 ) ) ) ?gen69 <- ( crime_art152_2 ( negative-overruled $?gen74 ) )"))

([rule7-support] of derived-attribute-rule
   (pos-name rule7-support-gen700)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule7] ) ) ) ?gen67 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen68 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen69 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen71 & : ( not ( subseq-pos ( create$ rule7 ?gen67 ?gen68 $$$ $?gen71 ) ) ) ) ) ( test ( eq ( class ?gen69 ) crime_art152_2 ) ) => ( calc ( bind $?gen74 ( create$ rule7 ?gen67 ?gen68 $?gen71 ) ) ) ?gen69 <- ( crime_art152_2 ( positive-support $?gen74 ) )"))

([rule6-defeasibly-dot] of derived-attribute-rule
   (pos-name rule6-defeasibly-dot-gen702)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule6] ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule6 $? ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) ( not ( and ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( negative ~ 2 ) ( positive-overruled $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ) ) => ?gen59 <- ( crime_art152_1 ( positive 0 ) )"))

([rule6-defeasibly] of derived-attribute-rule
   (pos-name rule6-defeasibly-gen704)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule6] ) ) ) ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ?gen59 <- ( crime_art152_1 ( positive 1 ) ( positive-derivator rule6 ?gen66 ) )"))

([rule6-overruled-dot] of derived-attribute-rule
   (pos-name rule6-overruled-dot-gen706)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule6] ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen62 ) ( negative-overruled $?gen63 & : ( subseq-pos ( create$ rule6-overruled $?gen62 $$$ $?gen63 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) ( not ( and ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( positive-defeated $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ) ) => ( calc ( bind $?gen64 ( delete-member$ $?gen63 ( create$ rule6-overruled $?gen62 ) ) ) ) ?gen59 <- ( crime_art152_1 ( negative-overruled $?gen64 ) )"))

([rule6-overruled] of derived-attribute-rule
   (pos-name rule6-overruled-gen708)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule6] ) ) ) ?gen66 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen65 & : ( >= ?gen65 1 ) ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen62 ) ( negative-overruled $?gen63 & : ( not ( subseq-pos ( create$ rule6-overruled $?gen62 $$$ $?gen63 ) ) ) ) ( positive-defeated $?gen61 & : ( not ( member$ rule6 $?gen61 ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ( calc ( bind $?gen64 ( create$ rule6-overruled $?gen62 $?gen63 ) ) ) ?gen59 <- ( crime_art152_1 ( negative-overruled $?gen64 ) )"))

([rule6-support] of derived-attribute-rule
   (pos-name rule6-support-gen710)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule6] ) ) ) ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen59 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive-support $?gen61 & : ( not ( subseq-pos ( create$ rule6 ?gen58 $$$ $?gen61 ) ) ) ) ) ( test ( eq ( class ?gen59 ) crime_art152_1 ) ) => ( calc ( bind $?gen64 ( create$ rule6 ?gen58 $?gen61 ) ) ) ?gen59 <- ( crime_art152_1 ( positive-support $?gen64 ) )"))

([rule5-defeasibly-dot] of derived-attribute-rule
   (pos-name rule5-defeasibly-dot-gen712)
   (depends-on declare crime_art151_5 lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule5] ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule5 $? ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) ( not ( and ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( negative ~ 2 ) ( positive-overruled $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ) ) => ?gen48 <- ( crime_art151_5 ( positive 0 ) )"))

([rule5-defeasibly] of derived-attribute-rule
   (pos-name rule5-defeasibly-gen714)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule5] ) ) ) ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ?gen48 <- ( crime_art151_5 ( positive 1 ) ( positive-derivator rule5 ?gen55 ?gen57 ) )"))

([rule5-overruled-dot] of derived-attribute-rule
   (pos-name rule5-overruled-dot-gen716)
   (depends-on declare crime_art151_5 lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule5] ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen51 ) ( negative-overruled $?gen52 & : ( subseq-pos ( create$ rule5-overruled $?gen51 $$$ $?gen52 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) ( not ( and ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( positive-defeated $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ) ) => ( calc ( bind $?gen53 ( delete-member$ $?gen52 ( create$ rule5-overruled $?gen51 ) ) ) ) ?gen48 <- ( crime_art151_5 ( negative-overruled $?gen53 ) )"))

([rule5-overruled] of derived-attribute-rule
   (pos-name rule5-overruled-gen718)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule5] ) ) ) ?gen55 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen54 & : ( >= ?gen54 1 ) ) ) ?gen57 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen56 & : ( >= ?gen56 1 ) ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen51 ) ( negative-overruled $?gen52 & : ( not ( subseq-pos ( create$ rule5-overruled $?gen51 $$$ $?gen52 ) ) ) ) ( positive-defeated $?gen50 & : ( not ( member$ rule5 $?gen50 ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ( calc ( bind $?gen53 ( create$ rule5-overruled $?gen51 $?gen52 ) ) ) ?gen48 <- ( crime_art151_5 ( negative-overruled $?gen53 ) )"))

([rule5-support] of derived-attribute-rule
   (pos-name rule5-support-gen720)
   (depends-on declare lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule5] ) ) ) ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen47 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ?gen48 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive-support $?gen50 & : ( not ( subseq-pos ( create$ rule5 ?gen46 ?gen47 $$$ $?gen50 ) ) ) ) ) ( test ( eq ( class ?gen48 ) crime_art151_5 ) ) => ( calc ( bind $?gen53 ( create$ rule5 ?gen46 ?gen47 $?gen50 ) ) ) ?gen48 <- ( crime_art151_5 ( positive-support $?gen53 ) )"))

([rule4-defeasibly-dot] of derived-attribute-rule
   (pos-name rule4-defeasibly-dot-gen722)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule4] ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule4 $? ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) ( not ( and ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( negative ~ 2 ) ( positive-overruled $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ) ) => ?gen36 <- ( crime_art151_4 ( positive 0 ) )"))

([rule4-defeasibly] of derived-attribute-rule
   (pos-name rule4-defeasibly-gen724)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule4] ) ) ) ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ?gen36 <- ( crime_art151_4 ( positive 1 ) ( positive-derivator rule4 ?gen43 ?gen45 ) )"))

([rule4-overruled-dot] of derived-attribute-rule
   (pos-name rule4-overruled-dot-gen726)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule4] ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen39 ) ( negative-overruled $?gen40 & : ( subseq-pos ( create$ rule4-overruled $?gen39 $$$ $?gen40 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) ( not ( and ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( positive-defeated $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ) ) => ( calc ( bind $?gen41 ( delete-member$ $?gen40 ( create$ rule4-overruled $?gen39 ) ) ) ) ?gen36 <- ( crime_art151_4 ( negative-overruled $?gen41 ) )"))

([rule4-overruled] of derived-attribute-rule
   (pos-name rule4-overruled-gen728)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule4] ) ) ) ?gen43 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen42 & : ( >= ?gen42 1 ) ) ) ?gen45 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen44 & : ( >= ?gen44 1 ) ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen39 ) ( negative-overruled $?gen40 & : ( not ( subseq-pos ( create$ rule4-overruled $?gen39 $$$ $?gen40 ) ) ) ) ( positive-defeated $?gen38 & : ( not ( member$ rule4 $?gen38 ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ( calc ( bind $?gen41 ( create$ rule4-overruled $?gen39 $?gen40 ) ) ) ?gen36 <- ( crime_art151_4 ( negative-overruled $?gen41 ) )"))

([rule4-support] of derived-attribute-rule
   (pos-name rule4-support-gen730)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule4] ) ) ) ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen35 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen36 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive-support $?gen38 & : ( not ( subseq-pos ( create$ rule4 ?gen34 ?gen35 $$$ $?gen38 ) ) ) ) ) ( test ( eq ( class ?gen36 ) crime_art151_4 ) ) => ( calc ( bind $?gen41 ( create$ rule4 ?gen34 ?gen35 $?gen38 ) ) ) ?gen36 <- ( crime_art151_4 ( positive-support $?gen41 ) )"))

([rule3-defeasibly-dot] of derived-attribute-rule
   (pos-name rule3-defeasibly-dot-gen732)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule3] ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule3 $? ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) ( not ( and ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( negative ~ 2 ) ( positive-overruled $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ) ) => ?gen24 <- ( crime_art151_3 ( positive 0 ) )"))

([rule3-defeasibly] of derived-attribute-rule
   (pos-name rule3-defeasibly-gen734)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule3] ) ) ) ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ?gen24 <- ( crime_art151_3 ( positive 1 ) ( positive-derivator rule3 ?gen31 ?gen33 ) )"))

([rule3-overruled-dot] of derived-attribute-rule
   (pos-name rule3-overruled-dot-gen736)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule3] ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen27 ) ( negative-overruled $?gen28 & : ( subseq-pos ( create$ rule3-overruled $?gen27 $$$ $?gen28 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) ( not ( and ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( positive-defeated $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ) ) => ( calc ( bind $?gen29 ( delete-member$ $?gen28 ( create$ rule3-overruled $?gen27 ) ) ) ) ?gen24 <- ( crime_art151_3 ( negative-overruled $?gen29 ) )"))

([rule3-overruled] of derived-attribute-rule
   (pos-name rule3-overruled-gen738)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule3] ) ) ) ?gen31 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen30 & : ( >= ?gen30 1 ) ) ) ?gen33 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ( positive ?gen32 & : ( >= ?gen32 1 ) ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen27 ) ( negative-overruled $?gen28 & : ( not ( subseq-pos ( create$ rule3-overruled $?gen27 $$$ $?gen28 ) ) ) ) ( positive-defeated $?gen26 & : ( not ( member$ rule3 $?gen26 ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ( calc ( bind $?gen29 ( create$ rule3-overruled $?gen27 $?gen28 ) ) ) ?gen24 <- ( crime_art151_3 ( negative-overruled $?gen29 ) )"))

([rule3-support] of derived-attribute-rule
   (pos-name rule3-support-gen740)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule3] ) ) ) ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen23 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ?gen24 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive-support $?gen26 & : ( not ( subseq-pos ( create$ rule3 ?gen22 ?gen23 $$$ $?gen26 ) ) ) ) ) ( test ( eq ( class ?gen24 ) crime_art151_3 ) ) => ( calc ( bind $?gen29 ( create$ rule3 ?gen22 ?gen23 $?gen26 ) ) ) ?gen24 <- ( crime_art151_3 ( positive-support $?gen29 ) )"))

([rule2-defeasibly-dot] of derived-attribute-rule
   (pos-name rule2-defeasibly-dot-gen742)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule2] ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule2 $? ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) ( not ( and ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ) ) => ?gen12 <- ( crime_art151_2 ( positive 0 ) )"))

([rule2-defeasibly] of derived-attribute-rule
   (pos-name rule2-defeasibly-gen744)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule2] ) ) ) ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ?gen12 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule2 ?gen19 ?gen21 ) )"))

([rule2-overruled-dot] of derived-attribute-rule
   (pos-name rule2-overruled-dot-gen746)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule2] ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen15 ) ( negative-overruled $?gen16 & : ( subseq-pos ( create$ rule2-overruled $?gen15 $$$ $?gen16 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) ( not ( and ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( positive-defeated $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ) ) => ( calc ( bind $?gen17 ( delete-member$ $?gen16 ( create$ rule2-overruled $?gen15 ) ) ) ) ?gen12 <- ( crime_art151_2 ( negative-overruled $?gen17 ) )"))

([rule2-overruled] of derived-attribute-rule
   (pos-name rule2-overruled-gen748)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule2] ) ) ) ?gen19 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen18 & : ( >= ?gen18 1 ) ) ) ?gen21 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen20 & : ( >= ?gen20 1 ) ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen15 ) ( negative-overruled $?gen16 & : ( not ( subseq-pos ( create$ rule2-overruled $?gen15 $$$ $?gen16 ) ) ) ) ( positive-defeated $?gen14 & : ( not ( member$ rule2 $?gen14 ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ( calc ( bind $?gen17 ( create$ rule2-overruled $?gen15 $?gen16 ) ) ) ?gen12 <- ( crime_art151_2 ( negative-overruled $?gen17 ) )"))

([rule2-support] of derived-attribute-rule
   (pos-name rule2-support-gen750)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule2] ) ) ) ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen11 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen12 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen14 & : ( not ( subseq-pos ( create$ rule2 ?gen10 ?gen11 $$$ $?gen14 ) ) ) ) ) ( test ( eq ( class ?gen12 ) crime_art151_2 ) ) => ( calc ( bind $?gen17 ( create$ rule2 ?gen10 ?gen11 $?gen14 ) ) ) ?gen12 <- ( crime_art151_2 ( positive-support $?gen17 ) )"))

([rule1-defeasibly-dot] of derived-attribute-rule
   (pos-name rule1-defeasibly-dot-gen752)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule1] ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule1 $? ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) ( not ( and ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( negative ~ 2 ) ( positive-overruled $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ) ) => ?gen2 <- ( crime_art151_1 ( positive 0 ) )"))

([rule1-defeasibly] of derived-attribute-rule
   (pos-name rule1-defeasibly-gen754)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule1] ) ) ) ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ?gen2 <- ( crime_art151_1 ( positive 1 ) ( positive-derivator rule1 ?gen9 ) )"))

([rule1-overruled-dot] of derived-attribute-rule
   (pos-name rule1-overruled-dot-gen756)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule1] ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen5 ) ( negative-overruled $?gen6 & : ( subseq-pos ( create$ rule1-overruled $?gen5 $$$ $?gen6 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) ( not ( and ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( positive-defeated $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ) ) => ( calc ( bind $?gen7 ( delete-member$ $?gen6 ( create$ rule1-overruled $?gen5 ) ) ) ) ?gen2 <- ( crime_art151_1 ( negative-overruled $?gen7 ) )"))

([rule1-overruled] of derived-attribute-rule
   (pos-name rule1-overruled-gen758)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule1] ) ) ) ?gen9 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen8 & : ( >= ?gen8 1 ) ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen5 ) ( negative-overruled $?gen6 & : ( not ( subseq-pos ( create$ rule1-overruled $?gen5 $$$ $?gen6 ) ) ) ) ( positive-defeated $?gen4 & : ( not ( member$ rule1 $?gen4 ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ( calc ( bind $?gen7 ( create$ rule1-overruled $?gen5 $?gen6 ) ) ) ?gen2 <- ( crime_art151_1 ( negative-overruled $?gen7 ) )"))

([rule1-support] of derived-attribute-rule
   (pos-name rule1-support-gen760)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule1] ) ) ) ?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen2 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive-support $?gen4 & : ( not ( subseq-pos ( create$ rule1 ?gen1 $$$ $?gen4 ) ) ) ) ) ( test ( eq ( class ?gen2 ) crime_art151_1 ) ) => ( calc ( bind $?gen7 ( create$ rule1 ?gen1 $?gen4 ) ) ) ?gen2 <- ( crime_art151_1 ( positive-support $?gen7 ) )"))

([rule34-deductive] of ntm-deductive-rule
   (pos-name rule34-deductive-gen421)
   (depends-on lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (deductive-rule "?gen376 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen377 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( not ( crime_art155_1 ( defendant ?Defendant ) ) ) => ( crime_art155_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule34-deductive-gen421 ( declare ( salience ( calc-salience crime_art155_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen376 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ( object ( name ?gen377 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( not ( object ( is-a crime_art155_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_1))

([rule33-deductive] of ntm-deductive-rule
   (pos-name rule33-deductive-gen420)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen364 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule33-deductive-gen420 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen364 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( object ( name ?gen365 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule32-deductive] of ntm-deductive-rule
   (pos-name rule32-deductive-gen419)
   (depends-on lc:case crime_art150)
   (implies crime_art150)
   (deductive-rule "?gen355 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ) ( not ( crime_art150 ( defendant ?Defendant ) ) ) => ( crime_art150 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule32-deductive-gen419 ( declare ( salience ( calc-salience crime_art150 ) ) ) ( run-deductive-rules ) ( object ( name ?gen355 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"pobacaj_izvrsen\" ) ) ( not ( object ( is-a crime_art150 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150 ?Defendant ) ) ) ( make-instance ?oid of crime_art150 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150))

([rule31-deductive] of ntm-deductive-rule
   (pos-name rule31-deductive-gen418)
   (depends-on lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (deductive-rule "?gen340 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen341 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen342 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( not ( crime_art157 ( defendant ?Defendant ) ) ) => ( crime_art157 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule31-deductive-gen418 ( declare ( salience ( calc-salience crime_art157 ) ) ) ( run-deductive-rules ) ( object ( name ?gen340 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen341 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ( object ( name ?gen342 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( not ( object ( is-a crime_art157 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art157 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art157 ?Defendant ) ) ) ( make-instance ?oid of crime_art157 ( defendant ?Defendant ) ) )")
   (derived-class crime_art157))

([rule30-deductive] of ntm-deductive-rule
   (pos-name rule30-deductive-gen417)
   (depends-on lc:case lc:case crime_art156)
   (implies crime_art156)
   (deductive-rule "?gen328 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( not ( crime_art156 ( defendant ?Defendant ) ) ) => ( crime_art156 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule30-deductive-gen417 ( declare ( salience ( calc-salience crime_art156 ) ) ) ( run-deductive-rules ) ( object ( name ?gen328 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen329 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( not ( object ( is-a crime_art156 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ( make-instance ?oid of crime_art156 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156))

([rule29-deductive] of ntm-deductive-rule
   (pos-name rule29-deductive-gen416)
   (depends-on lc:case lc:case crime_art156)
   (implies crime_art156)
   (deductive-rule "?gen316 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen317 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( not ( crime_art156 ( defendant ?Defendant ) ) ) => ( crime_art156 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule29-deductive-gen416 ( declare ( salience ( calc-salience crime_art156 ) ) ) ( run-deductive-rules ) ( object ( name ?gen316 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen317 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( not ( object ( is-a crime_art156 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ( make-instance ?oid of crime_art156 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156))

([rule28-deductive] of ntm-deductive-rule
   (pos-name rule28-deductive-gen415)
   (depends-on lc:case crime_art151b)
   (implies crime_art151b)
   (deductive-rule "?gen307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ( not ( crime_art151b ( defendant ?Defendant ) ) ) => ( crime_art151b ( defendant ?Defendant ) )")
   (production-rule "( defrule rule28-deductive-gen415 ( declare ( salience ( calc-salience crime_art151b ) ) ) ( run-deductive-rules ) ( object ( name ?gen307 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ( not ( object ( is-a crime_art151b ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ( make-instance ?oid of crime_art151b ( defendant ?Defendant ) ) )")
   (derived-class crime_art151b))

([rule27-deductive] of ntm-deductive-rule
   (pos-name rule27-deductive-gen414)
   (depends-on lc:case crime_art151b)
   (implies crime_art151b)
   (deductive-rule "?gen298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ( not ( crime_art151b ( defendant ?Defendant ) ) ) => ( crime_art151b ( defendant ?Defendant ) )")
   (production-rule "( defrule rule27-deductive-gen414 ( declare ( salience ( calc-salience crime_art151b ) ) ) ( run-deductive-rules ) ( object ( name ?gen298 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ( not ( object ( is-a crime_art151b ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ( make-instance ?oid of crime_art151b ( defendant ?Defendant ) ) )")
   (derived-class crime_art151b))

([rule26-deductive] of ntm-deductive-rule
   (pos-name rule26-deductive-gen413)
   (depends-on lc:case crime_art151a)
   (implies crime_art151a)
   (deductive-rule "?gen289 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ( not ( crime_art151a ( defendant ?Defendant ) ) ) => ( crime_art151a ( defendant ?Defendant ) )")
   (production-rule "( defrule rule26-deductive-gen413 ( declare ( salience ( calc-salience crime_art151a ) ) ) ( run-deductive-rules ) ( object ( name ?gen289 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ( not ( object ( is-a crime_art151a ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151a ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151a ?Defendant ) ) ) ( make-instance ?oid of crime_art151a ( defendant ?Defendant ) ) )")
   (derived-class crime_art151a))

([rule25-deductive] of ntm-deductive-rule
   (pos-name rule25-deductive-gen412)
   (depends-on lc:case crime_art150)
   (implies crime_art150)
   (deductive-rule "?gen280 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( not ( crime_art150 ( defendant ?Defendant ) ) ) => ( crime_art150 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule25-deductive-gen412 ( declare ( salience ( calc-salience crime_art150 ) ) ) ( run-deductive-rules ) ( object ( name ?gen280 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( not ( object ( is-a crime_art150 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150 ?Defendant ) ) ) ( make-instance ?oid of crime_art150 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150))

([rule24-deductive] of ntm-deductive-rule
   (pos-name rule24-deductive-gen411)
   (depends-on lc:case lc:case crime_art149_5)
   (implies crime_art149_5)
   (deductive-rule "?gen268 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ( not ( crime_art149_5 ( defendant ?Defendant ) ) ) => ( crime_art149_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule24-deductive-gen411 ( declare ( salience ( calc-salience crime_art149_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen268 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( object ( name ?gen269 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ( not ( object ( is-a crime_art149_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_5))

([rule23-deductive] of ntm-deductive-rule
   (pos-name rule23-deductive-gen410)
   (depends-on lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (deductive-rule "?gen256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( not ( crime_art149_2 ( defendant ?Defendant ) ) ) => ( crime_art149_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule23-deductive-gen410 ( declare ( salience ( calc-salience crime_art149_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen256 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( object ( name ?gen257 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( not ( object ( is-a crime_art149_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_2))

([rule22-deductive] of ntm-deductive-rule
   (pos-name rule22-deductive-gen409)
   (depends-on lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (deductive-rule "?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen245 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( not ( crime_art149_1 ( defendant ?Defendant ) ) ) => ( crime_art149_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule22-deductive-gen409 ( declare ( salience ( calc-salience crime_art149_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen244 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( object ( name ?gen245 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( not ( object ( is-a crime_art149_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_1))

([rule21-deductive] of ntm-deductive-rule
   (pos-name rule21-deductive-gen408)
   (depends-on lc:case lc:case crime_art148)
   (implies crime_art148)
   (deductive-rule "?gen232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( crime_art148 ( defendant ?Defendant ) ) ) => ( crime_art148 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule21-deductive-gen408 ( declare ( salience ( calc-salience crime_art148 ) ) ) ( run-deductive-rules ) ( object ( name ?gen232 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen233 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( object ( is-a crime_art148 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art148 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art148 ?Defendant ) ) ) ( make-instance ?oid of crime_art148 ( defendant ?Defendant ) ) )")
   (derived-class crime_art148))

([rule20-deductive] of ntm-deductive-rule
   (pos-name rule20-deductive-gen407)
   (depends-on lc:case lc:case crime_art147)
   (implies crime_art147)
   (deductive-rule "?gen220 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( not ( crime_art147 ( defendant ?Defendant ) ) ) => ( crime_art147 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule20-deductive-gen407 ( declare ( salience ( calc-salience crime_art147 ) ) ) ( run-deductive-rules ) ( object ( name ?gen220 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen221 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( not ( object ( is-a crime_art147 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art147 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art147 ?Defendant ) ) ) ( make-instance ?oid of crime_art147 ( defendant ?Defendant ) ) )")
   (derived-class crime_art147))

([rule19-deductive] of ntm-deductive-rule
   (pos-name rule19-deductive-gen406)
   (depends-on lc:case lc:case crime_art146)
   (implies crime_art146)
   (deductive-rule "?gen208 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ( not ( crime_art146 ( defendant ?Defendant ) ) ) => ( crime_art146 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule19-deductive-gen406 ( declare ( salience ( calc-salience crime_art146 ) ) ) ( run-deductive-rules ) ( object ( name ?gen208 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen209 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ( not ( object ( is-a crime_art146 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art146 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art146 ?Defendant ) ) ) ( make-instance ?oid of crime_art146 ( defendant ?Defendant ) ) )")
   (derived-class crime_art146))

([rule18-deductive] of ntm-deductive-rule
   (pos-name rule18-deductive-gen405)
   (depends-on lc:case lc:case crime_art145)
   (implies crime_art145)
   (deductive-rule "?gen196 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen197 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ) ( not ( crime_art145 ( defendant ?Defendant ) ) ) => ( crime_art145 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule18-deductive-gen405 ( declare ( salience ( calc-salience crime_art145 ) ) ) ( run-deductive-rules ) ( object ( name ?gen196 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen197 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"jaka_razdrazenost_na_mah\" ) ) ( not ( object ( is-a crime_art145 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ( make-instance ?oid of crime_art145 ( defendant ?Defendant ) ) )")
   (derived-class crime_art145))

([rule17-deductive] of ntm-deductive-rule
   (pos-name rule17-deductive-gen404)
   (depends-on lc:case lc:case crime_art145)
   (implies crime_art145)
   (deductive-rule "?gen184 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen185 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( not ( crime_art145 ( defendant ?Defendant ) ) ) => ( crime_art145 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule17-deductive-gen404 ( declare ( salience ( calc-salience crime_art145 ) ) ) ( run-deductive-rules ) ( object ( name ?gen184 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen185 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( not ( object ( is-a crime_art145 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ( make-instance ?oid of crime_art145 ( defendant ?Defendant ) ) )")
   (derived-class crime_art145))

([rule16-deductive] of ntm-deductive-rule
   (pos-name rule16-deductive-gen403)
   (depends-on lc:case lc:case crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen173 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule16-deductive-gen403 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen172 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen173 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule15-deductive] of ntm-deductive-rule
   (pos-name rule15-deductive-gen402)
   (depends-on lc:case lc:case crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen160 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule15-deductive-gen402 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen160 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen161 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule14-deductive] of ntm-deductive-rule
   (pos-name rule14-deductive-gen401)
   (depends-on lc:case lc:case crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen148 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule14-deductive-gen401 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen148 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen149 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule13-deductive] of ntm-deductive-rule
   (pos-name rule13-deductive-gen400)
   (depends-on lc:case lc:case crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen137 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule13-deductive-gen400 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen136 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen137 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule12-deductive] of ntm-deductive-rule
   (pos-name rule12-deductive-gen399)
   (depends-on lc:case lc:case crime_art143)
   (implies crime_art143)
   (deductive-rule "?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen125 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( not ( crime_art143 ( defendant ?Defendant ) ) ) => ( crime_art143 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule12-deductive-gen399 ( declare ( salience ( calc-salience crime_art143 ) ) ) ( run-deductive-rules ) ( object ( name ?gen124 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen125 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( not ( object ( is-a crime_art143 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ( make-instance ?oid of crime_art143 ( defendant ?Defendant ) ) )")
   (derived-class crime_art143))

([rule11-deductive] of ntm-deductive-rule
   (pos-name rule11-deductive-gen398)
   (depends-on lc:case lc:case crime_art143)
   (implies crime_art143)
   (deductive-rule "?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen113 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( not ( crime_art143 ( defendant ?Defendant ) ) ) => ( crime_art143 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule11-deductive-gen398 ( declare ( salience ( calc-salience crime_art143 ) ) ) ( run-deductive-rules ) ( object ( name ?gen112 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen113 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( not ( object ( is-a crime_art143 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ( make-instance ?oid of crime_art143 ( defendant ?Defendant ) ) )")
   (derived-class crime_art143))

([rule10-deductive] of ntm-deductive-rule
   (pos-name rule10-deductive-gen397)
   (depends-on lc:case lc:case crime_art155_1)
   (implies crime_art155_1)
   (deductive-rule "?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen101 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( crime_art155_1 ( defendant ?Defendant ) ) ) => ( crime_art155_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule10-deductive-gen397 ( declare ( salience ( calc-salience crime_art155_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen100 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen101 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( object ( is-a crime_art155_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_1))

([rule9-deductive] of ntm-deductive-rule
   (pos-name rule9-deductive-gen396)
   (depends-on lc:case crime_art154)
   (implies crime_art154)
   (deductive-rule "?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( not ( crime_art154 ( defendant ?Defendant ) ) ) => ( crime_art154 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule9-deductive-gen396 ( declare ( salience ( calc-salience crime_art154 ) ) ) ( run-deductive-rules ) ( object ( name ?gen91 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( not ( object ( is-a crime_art154 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ( make-instance ?oid of crime_art154 ( defendant ?Defendant ) ) )")
   (derived-class crime_art154))

([rule8-deductive] of ntm-deductive-rule
   (pos-name rule8-deductive-gen395)
   (depends-on lc:case lc:case crime_art153)
   (implies crime_art153)
   (deductive-rule "?gen79 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen80 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ( not ( crime_art153 ( defendant ?Defendant ) ) ) => ( crime_art153 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule8-deductive-gen395 ( declare ( salience ( calc-salience crime_art153 ) ) ) ( run-deductive-rules ) ( object ( name ?gen79 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen80 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ( not ( object ( is-a crime_art153 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ( make-instance ?oid of crime_art153 ( defendant ?Defendant ) ) )")
   (derived-class crime_art153))

([rule7-deductive] of ntm-deductive-rule
   (pos-name rule7-deductive-gen394)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen67 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen68 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule7-deductive-gen394 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen67 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( object ( name ?gen68 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule6-deductive] of ntm-deductive-rule
   (pos-name rule6-deductive-gen393)
   (depends-on lc:case crime_art152_1)
   (implies crime_art152_1)
   (deductive-rule "?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( crime_art152_1 ( defendant ?Defendant ) ) ) => ( crime_art152_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule6-deductive-gen393 ( declare ( salience ( calc-salience crime_art152_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen58 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( object ( is-a crime_art152_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_1))

([rule5-deductive] of ntm-deductive-rule
   (pos-name rule5-deductive-gen392)
   (depends-on lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (deductive-rule "?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen47 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( crime_art151_5 ( defendant ?Defendant ) ) ) => ( crime_art151_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule5-deductive-gen392 ( declare ( salience ( calc-salience crime_art151_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen46 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen47 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( object ( is-a crime_art151_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_5))

([rule4-deductive] of ntm-deductive-rule
   (pos-name rule4-deductive-gen391)
   (depends-on lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (deductive-rule "?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen35 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( crime_art151_4 ( defendant ?Defendant ) ) ) => ( crime_art151_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule4-deductive-gen391 ( declare ( salience ( calc-salience crime_art151_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen34 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen35 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( object ( is-a crime_art151_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_4))

([rule3-deductive] of ntm-deductive-rule
   (pos-name rule3-deductive-gen390)
   (depends-on lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (deductive-rule "?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen23 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ( not ( crime_art151_3 ( defendant ?Defendant ) ) ) => ( crime_art151_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule3-deductive-gen390 ( declare ( salience ( calc-salience crime_art151_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen22 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen23 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_consequence \"true\" ) ) ( not ( object ( is-a crime_art151_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_3))

([rule2-deductive] of ntm-deductive-rule
   (pos-name rule2-deductive-gen389)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen11 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule2-deductive-gen389 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen10 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen11 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule1-deductive] of ntm-deductive-rule
   (pos-name rule1-deductive-gen388)
   (depends-on lc:case crime_art151_1)
   (implies crime_art151_1)
   (deductive-rule "?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( crime_art151_1 ( defendant ?Defendant ) ) ) => ( crime_art151_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule1-deductive-gen388 ( declare ( salience ( calc-salience crime_art151_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( object ( is-a crime_art151_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_1))

