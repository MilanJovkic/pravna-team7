([rule73b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule73b-defeasibly-dot-gen1428)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule73b] ) ) ) ?gen1330 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule73b $? ) ) ( test ( eq ( class ?gen1330 ) crime_art144 ) ) ( not ( and ?gen1337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1336 & : ( >= ?gen1336 1 ) ) ) ?gen1339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1338 & : ( >= ?gen1338 1 ) ) ) ?gen1341 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1340 & : ( >= ?gen1340 1 ) ) ) ?gen1330 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen1332 & : ( not ( member$ rule73b $?gen1332 ) ) ) ) ) ) => ?gen1330 <- ( crime_art144 ( positive 0 ) )"))

([rule73b-defeasibly] of derived-attribute-rule
   (pos-name rule73b-defeasibly-gen1430)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule73b] ) ) ) ?gen1337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1336 & : ( >= ?gen1336 1 ) ) ) ?gen1339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1338 & : ( >= ?gen1338 1 ) ) ) ?gen1341 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1340 & : ( >= ?gen1340 1 ) ) ) ?gen1330 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1332 & : ( not ( member$ rule73b $?gen1332 ) ) ) ) ( test ( eq ( class ?gen1330 ) crime_art144 ) ) => ?gen1330 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule73b ?gen1337 ?gen1339 ?gen1341 ) )"))

([rule73b-overruled-dot] of derived-attribute-rule
   (pos-name rule73b-overruled-dot-gen1432)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule73b] ) ) ) ?gen1330 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen1333 ) ( negative-overruled $?gen1334 & : ( subseq-pos ( create$ rule73b-overruled $?gen1333 $$$ $?gen1334 ) ) ) ) ( test ( eq ( class ?gen1330 ) crime_art144 ) ) ( not ( and ?gen1337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1336 & : ( >= ?gen1336 1 ) ) ) ?gen1339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1338 & : ( >= ?gen1338 1 ) ) ) ?gen1341 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1340 & : ( >= ?gen1340 1 ) ) ) ?gen1330 <- ( crime_art144 ( positive-defeated $?gen1332 & : ( not ( member$ rule73b $?gen1332 ) ) ) ) ) ) => ( calc ( bind $?gen1335 ( delete-member$ $?gen1334 ( create$ rule73b-overruled $?gen1333 ) ) ) ) ?gen1330 <- ( crime_art144 ( negative-overruled $?gen1335 ) )"))

([rule73b-overruled] of derived-attribute-rule
   (pos-name rule73b-overruled-gen1434)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule73b] ) ) ) ?gen1337 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1336 & : ( >= ?gen1336 1 ) ) ) ?gen1339 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1338 & : ( >= ?gen1338 1 ) ) ) ?gen1341 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1340 & : ( >= ?gen1340 1 ) ) ) ?gen1330 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen1333 ) ( negative-overruled $?gen1334 & : ( not ( subseq-pos ( create$ rule73b-overruled $?gen1333 $$$ $?gen1334 ) ) ) ) ( positive-defeated $?gen1332 & : ( not ( member$ rule73b $?gen1332 ) ) ) ) ( test ( eq ( class ?gen1330 ) crime_art144 ) ) => ( calc ( bind $?gen1335 ( create$ rule73b-overruled $?gen1333 $?gen1334 ) ) ) ?gen1330 <- ( crime_art144 ( negative-overruled $?gen1335 ) )"))

([rule73b-support] of derived-attribute-rule
   (pos-name rule73b-support-gen1436)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule73b] ) ) ) ?gen1327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1328 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1329 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen1330 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen1332 & : ( not ( subseq-pos ( create$ rule73b ?gen1327 ?gen1328 ?gen1329 $$$ $?gen1332 ) ) ) ) ) ( test ( eq ( class ?gen1330 ) crime_art144 ) ) => ( calc ( bind $?gen1335 ( create$ rule73b ?gen1327 ?gen1328 ?gen1329 $?gen1332 ) ) ) ?gen1330 <- ( crime_art144 ( positive-support $?gen1335 ) )"))

([rule73-defeasibly-dot] of derived-attribute-rule
   (pos-name rule73-defeasibly-dot-gen1438)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule73] ) ) ) ?gen1315 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule73 $? ) ) ( test ( eq ( class ?gen1315 ) crime_art149_4 ) ) ( not ( and ?gen1322 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1321 & : ( >= ?gen1321 1 ) ) ) ?gen1324 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1323 & : ( >= ?gen1323 1 ) ) ) ?gen1326 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1325 & : ( >= ?gen1325 1 ) ) ) ?gen1315 <- ( crime_art149_4 ( negative ~ 2 ) ( positive-overruled $?gen1317 & : ( not ( member$ rule73 $?gen1317 ) ) ) ) ) ) => ?gen1315 <- ( crime_art149_4 ( positive 0 ) )"))

([rule73-defeasibly] of derived-attribute-rule
   (pos-name rule73-defeasibly-gen1440)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule73] ) ) ) ?gen1322 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1321 & : ( >= ?gen1321 1 ) ) ) ?gen1324 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1323 & : ( >= ?gen1323 1 ) ) ) ?gen1326 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1325 & : ( >= ?gen1325 1 ) ) ) ?gen1315 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1317 & : ( not ( member$ rule73 $?gen1317 ) ) ) ) ( test ( eq ( class ?gen1315 ) crime_art149_4 ) ) => ?gen1315 <- ( crime_art149_4 ( positive 1 ) ( positive-derivator rule73 ?gen1322 ?gen1324 ?gen1326 ) )"))

([rule73-overruled-dot] of derived-attribute-rule
   (pos-name rule73-overruled-dot-gen1442)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule73] ) ) ) ?gen1315 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen1318 ) ( negative-overruled $?gen1319 & : ( subseq-pos ( create$ rule73-overruled $?gen1318 $$$ $?gen1319 ) ) ) ) ( test ( eq ( class ?gen1315 ) crime_art149_4 ) ) ( not ( and ?gen1322 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1321 & : ( >= ?gen1321 1 ) ) ) ?gen1324 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1323 & : ( >= ?gen1323 1 ) ) ) ?gen1326 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1325 & : ( >= ?gen1325 1 ) ) ) ?gen1315 <- ( crime_art149_4 ( positive-defeated $?gen1317 & : ( not ( member$ rule73 $?gen1317 ) ) ) ) ) ) => ( calc ( bind $?gen1320 ( delete-member$ $?gen1319 ( create$ rule73-overruled $?gen1318 ) ) ) ) ?gen1315 <- ( crime_art149_4 ( negative-overruled $?gen1320 ) )"))

([rule73-overruled] of derived-attribute-rule
   (pos-name rule73-overruled-gen1444)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule73] ) ) ) ?gen1322 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1321 & : ( >= ?gen1321 1 ) ) ) ?gen1324 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen1323 & : ( >= ?gen1323 1 ) ) ) ?gen1326 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1325 & : ( >= ?gen1325 1 ) ) ) ?gen1315 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen1318 ) ( negative-overruled $?gen1319 & : ( not ( subseq-pos ( create$ rule73-overruled $?gen1318 $$$ $?gen1319 ) ) ) ) ( positive-defeated $?gen1317 & : ( not ( member$ rule73 $?gen1317 ) ) ) ) ( test ( eq ( class ?gen1315 ) crime_art149_4 ) ) => ( calc ( bind $?gen1320 ( create$ rule73-overruled $?gen1318 $?gen1319 ) ) ) ?gen1315 <- ( crime_art149_4 ( negative-overruled $?gen1320 ) )"))

([rule73-support] of derived-attribute-rule
   (pos-name rule73-support-gen1446)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule73] ) ) ) ?gen1312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1313 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1314 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen1315 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive-support $?gen1317 & : ( not ( subseq-pos ( create$ rule73 ?gen1312 ?gen1313 ?gen1314 $$$ $?gen1317 ) ) ) ) ) ( test ( eq ( class ?gen1315 ) crime_art149_4 ) ) => ( calc ( bind $?gen1320 ( create$ rule73 ?gen1312 ?gen1313 ?gen1314 $?gen1317 ) ) ) ?gen1315 <- ( crime_art149_4 ( positive-support $?gen1320 ) )"))

([rule72b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule72b-defeasibly-dot-gen1448)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule72b] ) ) ) ?gen1300 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule72b $? ) ) ( test ( eq ( class ?gen1300 ) crime_art144 ) ) ( not ( and ?gen1307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1306 & : ( >= ?gen1306 1 ) ) ) ?gen1309 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1308 & : ( >= ?gen1308 1 ) ) ) ?gen1311 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1310 & : ( >= ?gen1310 1 ) ) ) ?gen1300 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen1302 & : ( not ( member$ rule72b $?gen1302 ) ) ) ) ) ) => ?gen1300 <- ( crime_art144 ( positive 0 ) )"))

([rule72b-defeasibly] of derived-attribute-rule
   (pos-name rule72b-defeasibly-gen1450)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule72b] ) ) ) ?gen1307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1306 & : ( >= ?gen1306 1 ) ) ) ?gen1309 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1308 & : ( >= ?gen1308 1 ) ) ) ?gen1311 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1310 & : ( >= ?gen1310 1 ) ) ) ?gen1300 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1302 & : ( not ( member$ rule72b $?gen1302 ) ) ) ) ( test ( eq ( class ?gen1300 ) crime_art144 ) ) => ?gen1300 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule72b ?gen1307 ?gen1309 ?gen1311 ) )"))

([rule72b-overruled-dot] of derived-attribute-rule
   (pos-name rule72b-overruled-dot-gen1452)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule72b] ) ) ) ?gen1300 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen1303 ) ( negative-overruled $?gen1304 & : ( subseq-pos ( create$ rule72b-overruled $?gen1303 $$$ $?gen1304 ) ) ) ) ( test ( eq ( class ?gen1300 ) crime_art144 ) ) ( not ( and ?gen1307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1306 & : ( >= ?gen1306 1 ) ) ) ?gen1309 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1308 & : ( >= ?gen1308 1 ) ) ) ?gen1311 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1310 & : ( >= ?gen1310 1 ) ) ) ?gen1300 <- ( crime_art144 ( positive-defeated $?gen1302 & : ( not ( member$ rule72b $?gen1302 ) ) ) ) ) ) => ( calc ( bind $?gen1305 ( delete-member$ $?gen1304 ( create$ rule72b-overruled $?gen1303 ) ) ) ) ?gen1300 <- ( crime_art144 ( negative-overruled $?gen1305 ) )"))

([rule72b-overruled] of derived-attribute-rule
   (pos-name rule72b-overruled-gen1454)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule72b] ) ) ) ?gen1307 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1306 & : ( >= ?gen1306 1 ) ) ) ?gen1309 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1308 & : ( >= ?gen1308 1 ) ) ) ?gen1311 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1310 & : ( >= ?gen1310 1 ) ) ) ?gen1300 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen1303 ) ( negative-overruled $?gen1304 & : ( not ( subseq-pos ( create$ rule72b-overruled $?gen1303 $$$ $?gen1304 ) ) ) ) ( positive-defeated $?gen1302 & : ( not ( member$ rule72b $?gen1302 ) ) ) ) ( test ( eq ( class ?gen1300 ) crime_art144 ) ) => ( calc ( bind $?gen1305 ( create$ rule72b-overruled $?gen1303 $?gen1304 ) ) ) ?gen1300 <- ( crime_art144 ( negative-overruled $?gen1305 ) )"))

([rule72b-support] of derived-attribute-rule
   (pos-name rule72b-support-gen1456)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule72b] ) ) ) ?gen1297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1299 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen1300 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen1302 & : ( not ( subseq-pos ( create$ rule72b ?gen1297 ?gen1298 ?gen1299 $$$ $?gen1302 ) ) ) ) ) ( test ( eq ( class ?gen1300 ) crime_art144 ) ) => ( calc ( bind $?gen1305 ( create$ rule72b ?gen1297 ?gen1298 ?gen1299 $?gen1302 ) ) ) ?gen1300 <- ( crime_art144 ( positive-support $?gen1305 ) )"))

([rule72-defeasibly-dot] of derived-attribute-rule
   (pos-name rule72-defeasibly-dot-gen1458)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule72] ) ) ) ?gen1285 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule72 $? ) ) ( test ( eq ( class ?gen1285 ) crime_art149_4 ) ) ( not ( and ?gen1292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1291 & : ( >= ?gen1291 1 ) ) ) ?gen1294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1293 & : ( >= ?gen1293 1 ) ) ) ?gen1296 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1295 & : ( >= ?gen1295 1 ) ) ) ?gen1285 <- ( crime_art149_4 ( negative ~ 2 ) ( positive-overruled $?gen1287 & : ( not ( member$ rule72 $?gen1287 ) ) ) ) ) ) => ?gen1285 <- ( crime_art149_4 ( positive 0 ) )"))

([rule72-defeasibly] of derived-attribute-rule
   (pos-name rule72-defeasibly-gen1460)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule72] ) ) ) ?gen1292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1291 & : ( >= ?gen1291 1 ) ) ) ?gen1294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1293 & : ( >= ?gen1293 1 ) ) ) ?gen1296 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1295 & : ( >= ?gen1295 1 ) ) ) ?gen1285 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1287 & : ( not ( member$ rule72 $?gen1287 ) ) ) ) ( test ( eq ( class ?gen1285 ) crime_art149_4 ) ) => ?gen1285 <- ( crime_art149_4 ( positive 1 ) ( positive-derivator rule72 ?gen1292 ?gen1294 ?gen1296 ) )"))

([rule72-overruled-dot] of derived-attribute-rule
   (pos-name rule72-overruled-dot-gen1462)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule72] ) ) ) ?gen1285 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen1288 ) ( negative-overruled $?gen1289 & : ( subseq-pos ( create$ rule72-overruled $?gen1288 $$$ $?gen1289 ) ) ) ) ( test ( eq ( class ?gen1285 ) crime_art149_4 ) ) ( not ( and ?gen1292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1291 & : ( >= ?gen1291 1 ) ) ) ?gen1294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1293 & : ( >= ?gen1293 1 ) ) ) ?gen1296 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1295 & : ( >= ?gen1295 1 ) ) ) ?gen1285 <- ( crime_art149_4 ( positive-defeated $?gen1287 & : ( not ( member$ rule72 $?gen1287 ) ) ) ) ) ) => ( calc ( bind $?gen1290 ( delete-member$ $?gen1289 ( create$ rule72-overruled $?gen1288 ) ) ) ) ?gen1285 <- ( crime_art149_4 ( negative-overruled $?gen1290 ) )"))

([rule72-overruled] of derived-attribute-rule
   (pos-name rule72-overruled-gen1464)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule72] ) ) ) ?gen1292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1291 & : ( >= ?gen1291 1 ) ) ) ?gen1294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen1293 & : ( >= ?gen1293 1 ) ) ) ?gen1296 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen1295 & : ( >= ?gen1295 1 ) ) ) ?gen1285 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen1288 ) ( negative-overruled $?gen1289 & : ( not ( subseq-pos ( create$ rule72-overruled $?gen1288 $$$ $?gen1289 ) ) ) ) ( positive-defeated $?gen1287 & : ( not ( member$ rule72 $?gen1287 ) ) ) ) ( test ( eq ( class ?gen1285 ) crime_art149_4 ) ) => ( calc ( bind $?gen1290 ( create$ rule72-overruled $?gen1288 $?gen1289 ) ) ) ?gen1285 <- ( crime_art149_4 ( negative-overruled $?gen1290 ) )"))

([rule72-support] of derived-attribute-rule
   (pos-name rule72-support-gen1466)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule72] ) ) ) ?gen1282 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1283 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1284 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen1285 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive-support $?gen1287 & : ( not ( subseq-pos ( create$ rule72 ?gen1282 ?gen1283 ?gen1284 $$$ $?gen1287 ) ) ) ) ) ( test ( eq ( class ?gen1285 ) crime_art149_4 ) ) => ( calc ( bind $?gen1290 ( create$ rule72 ?gen1282 ?gen1283 ?gen1284 $?gen1287 ) ) ) ?gen1285 <- ( crime_art149_4 ( positive-support $?gen1290 ) )"))

([rule71-defeasibly-dot] of derived-attribute-rule
   (pos-name rule71-defeasibly-dot-gen1468)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule71] ) ) ) ?gen1262 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule71 $? ) ) ( test ( eq ( class ?gen1262 ) crime_art149_1 ) ) ( not ( and ?gen1269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1268 & : ( >= ?gen1268 1 ) ) ) ?gen1271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen1270 & : ( >= ?gen1270 1 ) ) ) ?gen1273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1272 & : ( >= ?gen1272 1 ) ) ) ?gen1275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1274 & : ( >= ?gen1274 1 ) ) ) ?gen1277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1276 & : ( >= ?gen1276 1 ) ) ) ?gen1279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1278 & : ( >= ?gen1278 1 ) ) ) ?gen1281 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1280 & : ( >= ?gen1280 1 ) ) ) ?gen1262 <- ( crime_art149_1 ( negative ~ 2 ) ( positive-overruled $?gen1264 & : ( not ( member$ rule71 $?gen1264 ) ) ) ) ) ) => ?gen1262 <- ( crime_art149_1 ( positive 0 ) )"))

([rule71-defeasibly] of derived-attribute-rule
   (pos-name rule71-defeasibly-gen1470)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule71] ) ) ) ?gen1269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1268 & : ( >= ?gen1268 1 ) ) ) ?gen1271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen1270 & : ( >= ?gen1270 1 ) ) ) ?gen1273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1272 & : ( >= ?gen1272 1 ) ) ) ?gen1275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1274 & : ( >= ?gen1274 1 ) ) ) ?gen1277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1276 & : ( >= ?gen1276 1 ) ) ) ?gen1279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1278 & : ( >= ?gen1278 1 ) ) ) ?gen1281 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1280 & : ( >= ?gen1280 1 ) ) ) ?gen1262 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1264 & : ( not ( member$ rule71 $?gen1264 ) ) ) ) ( test ( eq ( class ?gen1262 ) crime_art149_1 ) ) => ?gen1262 <- ( crime_art149_1 ( positive 1 ) ( positive-derivator rule71 ?gen1269 ?gen1271 ?gen1273 ?gen1275 ?gen1277 ?gen1279 ?gen1281 ) )"))

([rule71-overruled-dot] of derived-attribute-rule
   (pos-name rule71-overruled-dot-gen1472)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule71] ) ) ) ?gen1262 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen1265 ) ( negative-overruled $?gen1266 & : ( subseq-pos ( create$ rule71-overruled $?gen1265 $$$ $?gen1266 ) ) ) ) ( test ( eq ( class ?gen1262 ) crime_art149_1 ) ) ( not ( and ?gen1269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1268 & : ( >= ?gen1268 1 ) ) ) ?gen1271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen1270 & : ( >= ?gen1270 1 ) ) ) ?gen1273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1272 & : ( >= ?gen1272 1 ) ) ) ?gen1275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1274 & : ( >= ?gen1274 1 ) ) ) ?gen1277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1276 & : ( >= ?gen1276 1 ) ) ) ?gen1279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1278 & : ( >= ?gen1278 1 ) ) ) ?gen1281 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1280 & : ( >= ?gen1280 1 ) ) ) ?gen1262 <- ( crime_art149_1 ( positive-defeated $?gen1264 & : ( not ( member$ rule71 $?gen1264 ) ) ) ) ) ) => ( calc ( bind $?gen1267 ( delete-member$ $?gen1266 ( create$ rule71-overruled $?gen1265 ) ) ) ) ?gen1262 <- ( crime_art149_1 ( negative-overruled $?gen1267 ) )"))

([rule71-overruled] of derived-attribute-rule
   (pos-name rule71-overruled-gen1474)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule71] ) ) ) ?gen1269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1268 & : ( >= ?gen1268 1 ) ) ) ?gen1271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen1270 & : ( >= ?gen1270 1 ) ) ) ?gen1273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1272 & : ( >= ?gen1272 1 ) ) ) ?gen1275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1274 & : ( >= ?gen1274 1 ) ) ) ?gen1277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1276 & : ( >= ?gen1276 1 ) ) ) ?gen1279 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1278 & : ( >= ?gen1278 1 ) ) ) ?gen1281 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1280 & : ( >= ?gen1280 1 ) ) ) ?gen1262 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen1265 ) ( negative-overruled $?gen1266 & : ( not ( subseq-pos ( create$ rule71-overruled $?gen1265 $$$ $?gen1266 ) ) ) ) ( positive-defeated $?gen1264 & : ( not ( member$ rule71 $?gen1264 ) ) ) ) ( test ( eq ( class ?gen1262 ) crime_art149_1 ) ) => ( calc ( bind $?gen1267 ( create$ rule71-overruled $?gen1265 $?gen1266 ) ) ) ?gen1262 <- ( crime_art149_1 ( negative-overruled $?gen1267 ) )"))

([rule71-support] of derived-attribute-rule
   (pos-name rule71-support-gen1476)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule71] ) ) ) ?gen1255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen1257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen1258 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1259 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen1260 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1261 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ?gen1262 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive-support $?gen1264 & : ( not ( subseq-pos ( create$ rule71 ?gen1255 ?gen1256 ?gen1257 ?gen1258 ?gen1259 ?gen1260 ?gen1261 $$$ $?gen1264 ) ) ) ) ) ( test ( eq ( class ?gen1262 ) crime_art149_1 ) ) => ( calc ( bind $?gen1267 ( create$ rule71 ?gen1255 ?gen1256 ?gen1257 ?gen1258 ?gen1259 ?gen1260 ?gen1261 $?gen1264 ) ) ) ?gen1262 <- ( crime_art149_1 ( positive-support $?gen1267 ) )"))

([rule70-defeasibly-dot] of derived-attribute-rule
   (pos-name rule70-defeasibly-dot-gen1478)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule70] ) ) ) ?gen1235 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule70 $? ) ) ( test ( eq ( class ?gen1235 ) crime_art149_1 ) ) ( not ( and ?gen1242 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1241 & : ( >= ?gen1241 1 ) ) ) ?gen1244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen1243 & : ( >= ?gen1243 1 ) ) ) ?gen1246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1245 & : ( >= ?gen1245 1 ) ) ) ?gen1248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1247 & : ( >= ?gen1247 1 ) ) ) ?gen1250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1249 & : ( >= ?gen1249 1 ) ) ) ?gen1252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1251 & : ( >= ?gen1251 1 ) ) ) ?gen1254 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1253 & : ( >= ?gen1253 1 ) ) ) ?gen1235 <- ( crime_art149_1 ( negative ~ 2 ) ( positive-overruled $?gen1237 & : ( not ( member$ rule70 $?gen1237 ) ) ) ) ) ) => ?gen1235 <- ( crime_art149_1 ( positive 0 ) )"))

([rule70-defeasibly] of derived-attribute-rule
   (pos-name rule70-defeasibly-gen1480)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule70] ) ) ) ?gen1242 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1241 & : ( >= ?gen1241 1 ) ) ) ?gen1244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen1243 & : ( >= ?gen1243 1 ) ) ) ?gen1246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1245 & : ( >= ?gen1245 1 ) ) ) ?gen1248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1247 & : ( >= ?gen1247 1 ) ) ) ?gen1250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1249 & : ( >= ?gen1249 1 ) ) ) ?gen1252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1251 & : ( >= ?gen1251 1 ) ) ) ?gen1254 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1253 & : ( >= ?gen1253 1 ) ) ) ?gen1235 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1237 & : ( not ( member$ rule70 $?gen1237 ) ) ) ) ( test ( eq ( class ?gen1235 ) crime_art149_1 ) ) => ?gen1235 <- ( crime_art149_1 ( positive 1 ) ( positive-derivator rule70 ?gen1242 ?gen1244 ?gen1246 ?gen1248 ?gen1250 ?gen1252 ?gen1254 ) )"))

([rule70-overruled-dot] of derived-attribute-rule
   (pos-name rule70-overruled-dot-gen1482)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule70] ) ) ) ?gen1235 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen1238 ) ( negative-overruled $?gen1239 & : ( subseq-pos ( create$ rule70-overruled $?gen1238 $$$ $?gen1239 ) ) ) ) ( test ( eq ( class ?gen1235 ) crime_art149_1 ) ) ( not ( and ?gen1242 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1241 & : ( >= ?gen1241 1 ) ) ) ?gen1244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen1243 & : ( >= ?gen1243 1 ) ) ) ?gen1246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1245 & : ( >= ?gen1245 1 ) ) ) ?gen1248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1247 & : ( >= ?gen1247 1 ) ) ) ?gen1250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1249 & : ( >= ?gen1249 1 ) ) ) ?gen1252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1251 & : ( >= ?gen1251 1 ) ) ) ?gen1254 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1253 & : ( >= ?gen1253 1 ) ) ) ?gen1235 <- ( crime_art149_1 ( positive-defeated $?gen1237 & : ( not ( member$ rule70 $?gen1237 ) ) ) ) ) ) => ( calc ( bind $?gen1240 ( delete-member$ $?gen1239 ( create$ rule70-overruled $?gen1238 ) ) ) ) ?gen1235 <- ( crime_art149_1 ( negative-overruled $?gen1240 ) )"))

([rule70-overruled] of derived-attribute-rule
   (pos-name rule70-overruled-gen1484)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule70] ) ) ) ?gen1242 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen1241 & : ( >= ?gen1241 1 ) ) ) ?gen1244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen1243 & : ( >= ?gen1243 1 ) ) ) ?gen1246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen1245 & : ( >= ?gen1245 1 ) ) ) ?gen1248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen1247 & : ( >= ?gen1247 1 ) ) ) ?gen1250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen1249 & : ( >= ?gen1249 1 ) ) ) ?gen1252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen1251 & : ( >= ?gen1251 1 ) ) ) ?gen1254 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( negative ?gen1253 & : ( >= ?gen1253 1 ) ) ) ?gen1235 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen1238 ) ( negative-overruled $?gen1239 & : ( not ( subseq-pos ( create$ rule70-overruled $?gen1238 $$$ $?gen1239 ) ) ) ) ( positive-defeated $?gen1237 & : ( not ( member$ rule70 $?gen1237 ) ) ) ) ( test ( eq ( class ?gen1235 ) crime_art149_1 ) ) => ( calc ( bind $?gen1240 ( create$ rule70-overruled $?gen1238 $?gen1239 ) ) ) ?gen1235 <- ( crime_art149_1 ( negative-overruled $?gen1240 ) )"))

([rule70-support] of derived-attribute-rule
   (pos-name rule70-support-gen1486)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule70] ) ) ) ?gen1228 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen1230 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen1231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen1233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1234 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ?gen1235 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive-support $?gen1237 & : ( not ( subseq-pos ( create$ rule70 ?gen1228 ?gen1229 ?gen1230 ?gen1231 ?gen1232 ?gen1233 ?gen1234 $$$ $?gen1237 ) ) ) ) ) ( test ( eq ( class ?gen1235 ) crime_art149_1 ) ) => ( calc ( bind $?gen1240 ( create$ rule70 ?gen1228 ?gen1229 ?gen1230 ?gen1231 ?gen1232 ?gen1233 ?gen1234 $?gen1237 ) ) ) ?gen1235 <- ( crime_art149_1 ( positive-support $?gen1240 ) )"))

([rule69-defeasibly-dot] of derived-attribute-rule
   (pos-name rule69-defeasibly-dot-gen1488)
   (depends-on declare crime_art157_3 lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule69] ) ) ) ?gen1214 <- ( crime_art157_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule69 $? ) ) ( test ( eq ( class ?gen1214 ) crime_art157_3 ) ) ( not ( and ?gen1221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1220 & : ( >= ?gen1220 1 ) ) ) ?gen1223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1222 & : ( >= ?gen1222 1 ) ) ) ?gen1225 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1224 & : ( >= ?gen1224 1 ) ) ) ?gen1227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1226 & : ( >= ?gen1226 1 ) ) ) ?gen1214 <- ( crime_art157_3 ( negative ~ 2 ) ( positive-overruled $?gen1216 & : ( not ( member$ rule69 $?gen1216 ) ) ) ) ) ) => ?gen1214 <- ( crime_art157_3 ( positive 0 ) )"))

([rule69-defeasibly] of derived-attribute-rule
   (pos-name rule69-defeasibly-gen1490)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule69] ) ) ) ?gen1221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1220 & : ( >= ?gen1220 1 ) ) ) ?gen1223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1222 & : ( >= ?gen1222 1 ) ) ) ?gen1225 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1224 & : ( >= ?gen1224 1 ) ) ) ?gen1227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1226 & : ( >= ?gen1226 1 ) ) ) ?gen1214 <- ( crime_art157_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1216 & : ( not ( member$ rule69 $?gen1216 ) ) ) ) ( test ( eq ( class ?gen1214 ) crime_art157_3 ) ) => ?gen1214 <- ( crime_art157_3 ( positive 1 ) ( positive-derivator rule69 ?gen1221 ?gen1223 ?gen1225 ?gen1227 ) )"))

([rule69-overruled-dot] of derived-attribute-rule
   (pos-name rule69-overruled-dot-gen1492)
   (depends-on declare crime_art157_3 lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule69] ) ) ) ?gen1214 <- ( crime_art157_3 ( defendant ?Defendant ) ( negative-support $?gen1217 ) ( negative-overruled $?gen1218 & : ( subseq-pos ( create$ rule69-overruled $?gen1217 $$$ $?gen1218 ) ) ) ) ( test ( eq ( class ?gen1214 ) crime_art157_3 ) ) ( not ( and ?gen1221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1220 & : ( >= ?gen1220 1 ) ) ) ?gen1223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1222 & : ( >= ?gen1222 1 ) ) ) ?gen1225 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1224 & : ( >= ?gen1224 1 ) ) ) ?gen1227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1226 & : ( >= ?gen1226 1 ) ) ) ?gen1214 <- ( crime_art157_3 ( positive-defeated $?gen1216 & : ( not ( member$ rule69 $?gen1216 ) ) ) ) ) ) => ( calc ( bind $?gen1219 ( delete-member$ $?gen1218 ( create$ rule69-overruled $?gen1217 ) ) ) ) ?gen1214 <- ( crime_art157_3 ( negative-overruled $?gen1219 ) )"))

([rule69-overruled] of derived-attribute-rule
   (pos-name rule69-overruled-gen1494)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule69] ) ) ) ?gen1221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1220 & : ( >= ?gen1220 1 ) ) ) ?gen1223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1222 & : ( >= ?gen1222 1 ) ) ) ?gen1225 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1224 & : ( >= ?gen1224 1 ) ) ) ?gen1227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1226 & : ( >= ?gen1226 1 ) ) ) ?gen1214 <- ( crime_art157_3 ( defendant ?Defendant ) ( negative-support $?gen1217 ) ( negative-overruled $?gen1218 & : ( not ( subseq-pos ( create$ rule69-overruled $?gen1217 $$$ $?gen1218 ) ) ) ) ( positive-defeated $?gen1216 & : ( not ( member$ rule69 $?gen1216 ) ) ) ) ( test ( eq ( class ?gen1214 ) crime_art157_3 ) ) => ( calc ( bind $?gen1219 ( create$ rule69-overruled $?gen1217 $?gen1218 ) ) ) ?gen1214 <- ( crime_art157_3 ( negative-overruled $?gen1219 ) )"))

([rule69-support] of derived-attribute-rule
   (pos-name rule69-support-gen1496)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule69] ) ) ) ?gen1210 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1211 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1212 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen1213 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ?gen1214 <- ( crime_art157_3 ( defendant ?Defendant ) ( positive-support $?gen1216 & : ( not ( subseq-pos ( create$ rule69 ?gen1210 ?gen1211 ?gen1212 ?gen1213 $$$ $?gen1216 ) ) ) ) ) ( test ( eq ( class ?gen1214 ) crime_art157_3 ) ) => ( calc ( bind $?gen1219 ( create$ rule69 ?gen1210 ?gen1211 ?gen1212 ?gen1213 $?gen1216 ) ) ) ?gen1214 <- ( crime_art157_3 ( positive-support $?gen1219 ) )"))

([rule68-defeasibly-dot] of derived-attribute-rule
   (pos-name rule68-defeasibly-dot-gen1498)
   (depends-on declare crime_art157_2 lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule68] ) ) ) ?gen1196 <- ( crime_art157_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule68 $? ) ) ( test ( eq ( class ?gen1196 ) crime_art157_2 ) ) ( not ( and ?gen1203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1202 & : ( >= ?gen1202 1 ) ) ) ?gen1205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1204 & : ( >= ?gen1204 1 ) ) ) ?gen1207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1206 & : ( >= ?gen1206 1 ) ) ) ?gen1209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1208 & : ( >= ?gen1208 1 ) ) ) ?gen1196 <- ( crime_art157_2 ( negative ~ 2 ) ( positive-overruled $?gen1198 & : ( not ( member$ rule68 $?gen1198 ) ) ) ) ) ) => ?gen1196 <- ( crime_art157_2 ( positive 0 ) )"))

([rule68-defeasibly] of derived-attribute-rule
   (pos-name rule68-defeasibly-gen1500)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule68] ) ) ) ?gen1203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1202 & : ( >= ?gen1202 1 ) ) ) ?gen1205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1204 & : ( >= ?gen1204 1 ) ) ) ?gen1207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1206 & : ( >= ?gen1206 1 ) ) ) ?gen1209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1208 & : ( >= ?gen1208 1 ) ) ) ?gen1196 <- ( crime_art157_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1198 & : ( not ( member$ rule68 $?gen1198 ) ) ) ) ( test ( eq ( class ?gen1196 ) crime_art157_2 ) ) => ?gen1196 <- ( crime_art157_2 ( positive 1 ) ( positive-derivator rule68 ?gen1203 ?gen1205 ?gen1207 ?gen1209 ) )"))

([rule68-overruled-dot] of derived-attribute-rule
   (pos-name rule68-overruled-dot-gen1502)
   (depends-on declare crime_art157_2 lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule68] ) ) ) ?gen1196 <- ( crime_art157_2 ( defendant ?Defendant ) ( negative-support $?gen1199 ) ( negative-overruled $?gen1200 & : ( subseq-pos ( create$ rule68-overruled $?gen1199 $$$ $?gen1200 ) ) ) ) ( test ( eq ( class ?gen1196 ) crime_art157_2 ) ) ( not ( and ?gen1203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1202 & : ( >= ?gen1202 1 ) ) ) ?gen1205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1204 & : ( >= ?gen1204 1 ) ) ) ?gen1207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1206 & : ( >= ?gen1206 1 ) ) ) ?gen1209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1208 & : ( >= ?gen1208 1 ) ) ) ?gen1196 <- ( crime_art157_2 ( positive-defeated $?gen1198 & : ( not ( member$ rule68 $?gen1198 ) ) ) ) ) ) => ( calc ( bind $?gen1201 ( delete-member$ $?gen1200 ( create$ rule68-overruled $?gen1199 ) ) ) ) ?gen1196 <- ( crime_art157_2 ( negative-overruled $?gen1201 ) )"))

([rule68-overruled] of derived-attribute-rule
   (pos-name rule68-overruled-gen1504)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule68] ) ) ) ?gen1203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1202 & : ( >= ?gen1202 1 ) ) ) ?gen1205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1204 & : ( >= ?gen1204 1 ) ) ) ?gen1207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1206 & : ( >= ?gen1206 1 ) ) ) ?gen1209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1208 & : ( >= ?gen1208 1 ) ) ) ?gen1196 <- ( crime_art157_2 ( defendant ?Defendant ) ( negative-support $?gen1199 ) ( negative-overruled $?gen1200 & : ( not ( subseq-pos ( create$ rule68-overruled $?gen1199 $$$ $?gen1200 ) ) ) ) ( positive-defeated $?gen1198 & : ( not ( member$ rule68 $?gen1198 ) ) ) ) ( test ( eq ( class ?gen1196 ) crime_art157_2 ) ) => ( calc ( bind $?gen1201 ( create$ rule68-overruled $?gen1199 $?gen1200 ) ) ) ?gen1196 <- ( crime_art157_2 ( negative-overruled $?gen1201 ) )"))

([rule68-support] of derived-attribute-rule
   (pos-name rule68-support-gen1506)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule68] ) ) ) ?gen1192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1194 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen1195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ?gen1196 <- ( crime_art157_2 ( defendant ?Defendant ) ( positive-support $?gen1198 & : ( not ( subseq-pos ( create$ rule68 ?gen1192 ?gen1193 ?gen1194 ?gen1195 $$$ $?gen1198 ) ) ) ) ) ( test ( eq ( class ?gen1196 ) crime_art157_2 ) ) => ( calc ( bind $?gen1201 ( create$ rule68 ?gen1192 ?gen1193 ?gen1194 ?gen1195 $?gen1198 ) ) ) ?gen1196 <- ( crime_art157_2 ( positive-support $?gen1201 ) )"))

([rule67-defeasibly-dot] of derived-attribute-rule
   (pos-name rule67-defeasibly-dot-gen1508)
   (depends-on declare crime_art157 lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule67] ) ) ) ?gen1180 <- ( crime_art157 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule67 $? ) ) ( test ( eq ( class ?gen1180 ) crime_art157 ) ) ( not ( and ?gen1187 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1186 & : ( >= ?gen1186 1 ) ) ) ?gen1189 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1188 & : ( >= ?gen1188 1 ) ) ) ?gen1191 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1190 & : ( >= ?gen1190 1 ) ) ) ?gen1180 <- ( crime_art157 ( negative ~ 2 ) ( positive-overruled $?gen1182 & : ( not ( member$ rule67 $?gen1182 ) ) ) ) ) ) => ?gen1180 <- ( crime_art157 ( positive 0 ) )"))

([rule67-defeasibly] of derived-attribute-rule
   (pos-name rule67-defeasibly-gen1510)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule67] ) ) ) ?gen1187 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1186 & : ( >= ?gen1186 1 ) ) ) ?gen1189 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1188 & : ( >= ?gen1188 1 ) ) ) ?gen1191 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1190 & : ( >= ?gen1190 1 ) ) ) ?gen1180 <- ( crime_art157 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1182 & : ( not ( member$ rule67 $?gen1182 ) ) ) ) ( test ( eq ( class ?gen1180 ) crime_art157 ) ) => ?gen1180 <- ( crime_art157 ( positive 1 ) ( positive-derivator rule67 ?gen1187 ?gen1189 ?gen1191 ) )"))

([rule67-overruled-dot] of derived-attribute-rule
   (pos-name rule67-overruled-dot-gen1512)
   (depends-on declare crime_art157 lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule67] ) ) ) ?gen1180 <- ( crime_art157 ( defendant ?Defendant ) ( negative-support $?gen1183 ) ( negative-overruled $?gen1184 & : ( subseq-pos ( create$ rule67-overruled $?gen1183 $$$ $?gen1184 ) ) ) ) ( test ( eq ( class ?gen1180 ) crime_art157 ) ) ( not ( and ?gen1187 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1186 & : ( >= ?gen1186 1 ) ) ) ?gen1189 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1188 & : ( >= ?gen1188 1 ) ) ) ?gen1191 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1190 & : ( >= ?gen1190 1 ) ) ) ?gen1180 <- ( crime_art157 ( positive-defeated $?gen1182 & : ( not ( member$ rule67 $?gen1182 ) ) ) ) ) ) => ( calc ( bind $?gen1185 ( delete-member$ $?gen1184 ( create$ rule67-overruled $?gen1183 ) ) ) ) ?gen1180 <- ( crime_art157 ( negative-overruled $?gen1185 ) )"))

([rule67-overruled] of derived-attribute-rule
   (pos-name rule67-overruled-gen1514)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule67] ) ) ) ?gen1187 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1186 & : ( >= ?gen1186 1 ) ) ) ?gen1189 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ( positive ?gen1188 & : ( >= ?gen1188 1 ) ) ) ?gen1191 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ( positive ?gen1190 & : ( >= ?gen1190 1 ) ) ) ?gen1180 <- ( crime_art157 ( defendant ?Defendant ) ( negative-support $?gen1183 ) ( negative-overruled $?gen1184 & : ( not ( subseq-pos ( create$ rule67-overruled $?gen1183 $$$ $?gen1184 ) ) ) ) ( positive-defeated $?gen1182 & : ( not ( member$ rule67 $?gen1182 ) ) ) ) ( test ( eq ( class ?gen1180 ) crime_art157 ) ) => ( calc ( bind $?gen1185 ( create$ rule67-overruled $?gen1183 $?gen1184 ) ) ) ?gen1180 <- ( crime_art157 ( negative-overruled $?gen1185 ) )"))

([rule67-support] of derived-attribute-rule
   (pos-name rule67-support-gen1516)
   (depends-on declare lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule67] ) ) ) ?gen1177 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1179 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen1180 <- ( crime_art157 ( defendant ?Defendant ) ( positive-support $?gen1182 & : ( not ( subseq-pos ( create$ rule67 ?gen1177 ?gen1178 ?gen1179 $$$ $?gen1182 ) ) ) ) ) ( test ( eq ( class ?gen1180 ) crime_art157 ) ) => ( calc ( bind $?gen1185 ( create$ rule67 ?gen1177 ?gen1178 ?gen1179 $?gen1182 ) ) ) ?gen1180 <- ( crime_art157 ( positive-support $?gen1185 ) )"))

([rule66-defeasibly-dot] of derived-attribute-rule
   (pos-name rule66-defeasibly-dot-gen1518)
   (depends-on declare crime_art156_3 lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule66] ) ) ) ?gen1165 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule66 $? ) ) ( test ( eq ( class ?gen1165 ) crime_art156_3 ) ) ( not ( and ?gen1172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1171 & : ( >= ?gen1171 1 ) ) ) ?gen1174 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1173 & : ( >= ?gen1173 1 ) ) ) ?gen1176 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1175 & : ( >= ?gen1175 1 ) ) ) ?gen1165 <- ( crime_art156_3 ( negative ~ 2 ) ( positive-overruled $?gen1167 & : ( not ( member$ rule66 $?gen1167 ) ) ) ) ) ) => ?gen1165 <- ( crime_art156_3 ( positive 0 ) )"))

([rule66-defeasibly] of derived-attribute-rule
   (pos-name rule66-defeasibly-gen1520)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule66] ) ) ) ?gen1172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1171 & : ( >= ?gen1171 1 ) ) ) ?gen1174 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1173 & : ( >= ?gen1173 1 ) ) ) ?gen1176 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1175 & : ( >= ?gen1175 1 ) ) ) ?gen1165 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1167 & : ( not ( member$ rule66 $?gen1167 ) ) ) ) ( test ( eq ( class ?gen1165 ) crime_art156_3 ) ) => ?gen1165 <- ( crime_art156_3 ( positive 1 ) ( positive-derivator rule66 ?gen1172 ?gen1174 ?gen1176 ) )"))

([rule66-overruled-dot] of derived-attribute-rule
   (pos-name rule66-overruled-dot-gen1522)
   (depends-on declare crime_art156_3 lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule66] ) ) ) ?gen1165 <- ( crime_art156_3 ( defendant ?Defendant ) ( negative-support $?gen1168 ) ( negative-overruled $?gen1169 & : ( subseq-pos ( create$ rule66-overruled $?gen1168 $$$ $?gen1169 ) ) ) ) ( test ( eq ( class ?gen1165 ) crime_art156_3 ) ) ( not ( and ?gen1172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1171 & : ( >= ?gen1171 1 ) ) ) ?gen1174 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1173 & : ( >= ?gen1173 1 ) ) ) ?gen1176 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1175 & : ( >= ?gen1175 1 ) ) ) ?gen1165 <- ( crime_art156_3 ( positive-defeated $?gen1167 & : ( not ( member$ rule66 $?gen1167 ) ) ) ) ) ) => ( calc ( bind $?gen1170 ( delete-member$ $?gen1169 ( create$ rule66-overruled $?gen1168 ) ) ) ) ?gen1165 <- ( crime_art156_3 ( negative-overruled $?gen1170 ) )"))

([rule66-overruled] of derived-attribute-rule
   (pos-name rule66-overruled-gen1524)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule66] ) ) ) ?gen1172 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1171 & : ( >= ?gen1171 1 ) ) ) ?gen1174 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1173 & : ( >= ?gen1173 1 ) ) ) ?gen1176 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1175 & : ( >= ?gen1175 1 ) ) ) ?gen1165 <- ( crime_art156_3 ( defendant ?Defendant ) ( negative-support $?gen1168 ) ( negative-overruled $?gen1169 & : ( not ( subseq-pos ( create$ rule66-overruled $?gen1168 $$$ $?gen1169 ) ) ) ) ( positive-defeated $?gen1167 & : ( not ( member$ rule66 $?gen1167 ) ) ) ) ( test ( eq ( class ?gen1165 ) crime_art156_3 ) ) => ( calc ( bind $?gen1170 ( create$ rule66-overruled $?gen1168 $?gen1169 ) ) ) ?gen1165 <- ( crime_art156_3 ( negative-overruled $?gen1170 ) )"))

([rule66-support] of derived-attribute-rule
   (pos-name rule66-support-gen1526)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule66] ) ) ) ?gen1162 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1163 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen1164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ?gen1165 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive-support $?gen1167 & : ( not ( subseq-pos ( create$ rule66 ?gen1162 ?gen1163 ?gen1164 $$$ $?gen1167 ) ) ) ) ) ( test ( eq ( class ?gen1165 ) crime_art156_3 ) ) => ( calc ( bind $?gen1170 ( create$ rule66 ?gen1162 ?gen1163 ?gen1164 $?gen1167 ) ) ) ?gen1165 <- ( crime_art156_3 ( positive-support $?gen1170 ) )"))

([rule65-defeasibly-dot] of derived-attribute-rule
   (pos-name rule65-defeasibly-dot-gen1528)
   (depends-on declare crime_art156_3 lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule65] ) ) ) ?gen1150 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule65 $? ) ) ( test ( eq ( class ?gen1150 ) crime_art156_3 ) ) ( not ( and ?gen1157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1156 & : ( >= ?gen1156 1 ) ) ) ?gen1159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1158 & : ( >= ?gen1158 1 ) ) ) ?gen1161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1160 & : ( >= ?gen1160 1 ) ) ) ?gen1150 <- ( crime_art156_3 ( negative ~ 2 ) ( positive-overruled $?gen1152 & : ( not ( member$ rule65 $?gen1152 ) ) ) ) ) ) => ?gen1150 <- ( crime_art156_3 ( positive 0 ) )"))

([rule65-defeasibly] of derived-attribute-rule
   (pos-name rule65-defeasibly-gen1530)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule65] ) ) ) ?gen1157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1156 & : ( >= ?gen1156 1 ) ) ) ?gen1159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1158 & : ( >= ?gen1158 1 ) ) ) ?gen1161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1160 & : ( >= ?gen1160 1 ) ) ) ?gen1150 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1152 & : ( not ( member$ rule65 $?gen1152 ) ) ) ) ( test ( eq ( class ?gen1150 ) crime_art156_3 ) ) => ?gen1150 <- ( crime_art156_3 ( positive 1 ) ( positive-derivator rule65 ?gen1157 ?gen1159 ?gen1161 ) )"))

([rule65-overruled-dot] of derived-attribute-rule
   (pos-name rule65-overruled-dot-gen1532)
   (depends-on declare crime_art156_3 lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule65] ) ) ) ?gen1150 <- ( crime_art156_3 ( defendant ?Defendant ) ( negative-support $?gen1153 ) ( negative-overruled $?gen1154 & : ( subseq-pos ( create$ rule65-overruled $?gen1153 $$$ $?gen1154 ) ) ) ) ( test ( eq ( class ?gen1150 ) crime_art156_3 ) ) ( not ( and ?gen1157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1156 & : ( >= ?gen1156 1 ) ) ) ?gen1159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1158 & : ( >= ?gen1158 1 ) ) ) ?gen1161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1160 & : ( >= ?gen1160 1 ) ) ) ?gen1150 <- ( crime_art156_3 ( positive-defeated $?gen1152 & : ( not ( member$ rule65 $?gen1152 ) ) ) ) ) ) => ( calc ( bind $?gen1155 ( delete-member$ $?gen1154 ( create$ rule65-overruled $?gen1153 ) ) ) ) ?gen1150 <- ( crime_art156_3 ( negative-overruled $?gen1155 ) )"))

([rule65-overruled] of derived-attribute-rule
   (pos-name rule65-overruled-gen1534)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule65] ) ) ) ?gen1157 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1156 & : ( >= ?gen1156 1 ) ) ) ?gen1159 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1158 & : ( >= ?gen1158 1 ) ) ) ?gen1161 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1160 & : ( >= ?gen1160 1 ) ) ) ?gen1150 <- ( crime_art156_3 ( defendant ?Defendant ) ( negative-support $?gen1153 ) ( negative-overruled $?gen1154 & : ( not ( subseq-pos ( create$ rule65-overruled $?gen1153 $$$ $?gen1154 ) ) ) ) ( positive-defeated $?gen1152 & : ( not ( member$ rule65 $?gen1152 ) ) ) ) ( test ( eq ( class ?gen1150 ) crime_art156_3 ) ) => ( calc ( bind $?gen1155 ( create$ rule65-overruled $?gen1153 $?gen1154 ) ) ) ?gen1150 <- ( crime_art156_3 ( negative-overruled $?gen1155 ) )"))

([rule65-support] of derived-attribute-rule
   (pos-name rule65-support-gen1536)
   (depends-on declare lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule65] ) ) ) ?gen1147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1148 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen1149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ?gen1150 <- ( crime_art156_3 ( defendant ?Defendant ) ( positive-support $?gen1152 & : ( not ( subseq-pos ( create$ rule65 ?gen1147 ?gen1148 ?gen1149 $$$ $?gen1152 ) ) ) ) ) ( test ( eq ( class ?gen1150 ) crime_art156_3 ) ) => ( calc ( bind $?gen1155 ( create$ rule65 ?gen1147 ?gen1148 ?gen1149 $?gen1152 ) ) ) ?gen1150 <- ( crime_art156_3 ( positive-support $?gen1155 ) )"))

([rule64-defeasibly-dot] of derived-attribute-rule
   (pos-name rule64-defeasibly-dot-gen1538)
   (depends-on declare crime_art156_2 lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule64] ) ) ) ?gen1135 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule64 $? ) ) ( test ( eq ( class ?gen1135 ) crime_art156_2 ) ) ( not ( and ?gen1142 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1141 & : ( >= ?gen1141 1 ) ) ) ?gen1144 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1143 & : ( >= ?gen1143 1 ) ) ) ?gen1146 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1145 & : ( >= ?gen1145 1 ) ) ) ?gen1135 <- ( crime_art156_2 ( negative ~ 2 ) ( positive-overruled $?gen1137 & : ( not ( member$ rule64 $?gen1137 ) ) ) ) ) ) => ?gen1135 <- ( crime_art156_2 ( positive 0 ) )"))

([rule64-defeasibly] of derived-attribute-rule
   (pos-name rule64-defeasibly-gen1540)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule64] ) ) ) ?gen1142 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1141 & : ( >= ?gen1141 1 ) ) ) ?gen1144 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1143 & : ( >= ?gen1143 1 ) ) ) ?gen1146 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1145 & : ( >= ?gen1145 1 ) ) ) ?gen1135 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1137 & : ( not ( member$ rule64 $?gen1137 ) ) ) ) ( test ( eq ( class ?gen1135 ) crime_art156_2 ) ) => ?gen1135 <- ( crime_art156_2 ( positive 1 ) ( positive-derivator rule64 ?gen1142 ?gen1144 ?gen1146 ) )"))

([rule64-overruled-dot] of derived-attribute-rule
   (pos-name rule64-overruled-dot-gen1542)
   (depends-on declare crime_art156_2 lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule64] ) ) ) ?gen1135 <- ( crime_art156_2 ( defendant ?Defendant ) ( negative-support $?gen1138 ) ( negative-overruled $?gen1139 & : ( subseq-pos ( create$ rule64-overruled $?gen1138 $$$ $?gen1139 ) ) ) ) ( test ( eq ( class ?gen1135 ) crime_art156_2 ) ) ( not ( and ?gen1142 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1141 & : ( >= ?gen1141 1 ) ) ) ?gen1144 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1143 & : ( >= ?gen1143 1 ) ) ) ?gen1146 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1145 & : ( >= ?gen1145 1 ) ) ) ?gen1135 <- ( crime_art156_2 ( positive-defeated $?gen1137 & : ( not ( member$ rule64 $?gen1137 ) ) ) ) ) ) => ( calc ( bind $?gen1140 ( delete-member$ $?gen1139 ( create$ rule64-overruled $?gen1138 ) ) ) ) ?gen1135 <- ( crime_art156_2 ( negative-overruled $?gen1140 ) )"))

([rule64-overruled] of derived-attribute-rule
   (pos-name rule64-overruled-gen1544)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule64] ) ) ) ?gen1142 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1141 & : ( >= ?gen1141 1 ) ) ) ?gen1144 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1143 & : ( >= ?gen1143 1 ) ) ) ?gen1146 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1145 & : ( >= ?gen1145 1 ) ) ) ?gen1135 <- ( crime_art156_2 ( defendant ?Defendant ) ( negative-support $?gen1138 ) ( negative-overruled $?gen1139 & : ( not ( subseq-pos ( create$ rule64-overruled $?gen1138 $$$ $?gen1139 ) ) ) ) ( positive-defeated $?gen1137 & : ( not ( member$ rule64 $?gen1137 ) ) ) ) ( test ( eq ( class ?gen1135 ) crime_art156_2 ) ) => ( calc ( bind $?gen1140 ( create$ rule64-overruled $?gen1138 $?gen1139 ) ) ) ?gen1135 <- ( crime_art156_2 ( negative-overruled $?gen1140 ) )"))

([rule64-support] of derived-attribute-rule
   (pos-name rule64-support-gen1546)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule64] ) ) ) ?gen1132 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen1134 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ?gen1135 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive-support $?gen1137 & : ( not ( subseq-pos ( create$ rule64 ?gen1132 ?gen1133 ?gen1134 $$$ $?gen1137 ) ) ) ) ) ( test ( eq ( class ?gen1135 ) crime_art156_2 ) ) => ( calc ( bind $?gen1140 ( create$ rule64 ?gen1132 ?gen1133 ?gen1134 $?gen1137 ) ) ) ?gen1135 <- ( crime_art156_2 ( positive-support $?gen1140 ) )"))

([rule63-defeasibly-dot] of derived-attribute-rule
   (pos-name rule63-defeasibly-dot-gen1548)
   (depends-on declare crime_art156_2 lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule63] ) ) ) ?gen1120 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule63 $? ) ) ( test ( eq ( class ?gen1120 ) crime_art156_2 ) ) ( not ( and ?gen1127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1126 & : ( >= ?gen1126 1 ) ) ) ?gen1129 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1128 & : ( >= ?gen1128 1 ) ) ) ?gen1131 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1130 & : ( >= ?gen1130 1 ) ) ) ?gen1120 <- ( crime_art156_2 ( negative ~ 2 ) ( positive-overruled $?gen1122 & : ( not ( member$ rule63 $?gen1122 ) ) ) ) ) ) => ?gen1120 <- ( crime_art156_2 ( positive 0 ) )"))

([rule63-defeasibly] of derived-attribute-rule
   (pos-name rule63-defeasibly-gen1550)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule63] ) ) ) ?gen1127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1126 & : ( >= ?gen1126 1 ) ) ) ?gen1129 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1128 & : ( >= ?gen1128 1 ) ) ) ?gen1131 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1130 & : ( >= ?gen1130 1 ) ) ) ?gen1120 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1122 & : ( not ( member$ rule63 $?gen1122 ) ) ) ) ( test ( eq ( class ?gen1120 ) crime_art156_2 ) ) => ?gen1120 <- ( crime_art156_2 ( positive 1 ) ( positive-derivator rule63 ?gen1127 ?gen1129 ?gen1131 ) )"))

([rule63-overruled-dot] of derived-attribute-rule
   (pos-name rule63-overruled-dot-gen1552)
   (depends-on declare crime_art156_2 lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule63] ) ) ) ?gen1120 <- ( crime_art156_2 ( defendant ?Defendant ) ( negative-support $?gen1123 ) ( negative-overruled $?gen1124 & : ( subseq-pos ( create$ rule63-overruled $?gen1123 $$$ $?gen1124 ) ) ) ) ( test ( eq ( class ?gen1120 ) crime_art156_2 ) ) ( not ( and ?gen1127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1126 & : ( >= ?gen1126 1 ) ) ) ?gen1129 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1128 & : ( >= ?gen1128 1 ) ) ) ?gen1131 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1130 & : ( >= ?gen1130 1 ) ) ) ?gen1120 <- ( crime_art156_2 ( positive-defeated $?gen1122 & : ( not ( member$ rule63 $?gen1122 ) ) ) ) ) ) => ( calc ( bind $?gen1125 ( delete-member$ $?gen1124 ( create$ rule63-overruled $?gen1123 ) ) ) ) ?gen1120 <- ( crime_art156_2 ( negative-overruled $?gen1125 ) )"))

([rule63-overruled] of derived-attribute-rule
   (pos-name rule63-overruled-gen1554)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule63] ) ) ) ?gen1127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1126 & : ( >= ?gen1126 1 ) ) ) ?gen1129 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1128 & : ( >= ?gen1128 1 ) ) ) ?gen1131 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ( positive ?gen1130 & : ( >= ?gen1130 1 ) ) ) ?gen1120 <- ( crime_art156_2 ( defendant ?Defendant ) ( negative-support $?gen1123 ) ( negative-overruled $?gen1124 & : ( not ( subseq-pos ( create$ rule63-overruled $?gen1123 $$$ $?gen1124 ) ) ) ) ( positive-defeated $?gen1122 & : ( not ( member$ rule63 $?gen1122 ) ) ) ) ( test ( eq ( class ?gen1120 ) crime_art156_2 ) ) => ( calc ( bind $?gen1125 ( create$ rule63-overruled $?gen1123 $?gen1124 ) ) ) ?gen1120 <- ( crime_art156_2 ( negative-overruled $?gen1125 ) )"))

([rule63-support] of derived-attribute-rule
   (pos-name rule63-support-gen1556)
   (depends-on declare lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule63] ) ) ) ?gen1117 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1118 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen1119 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ?gen1120 <- ( crime_art156_2 ( defendant ?Defendant ) ( positive-support $?gen1122 & : ( not ( subseq-pos ( create$ rule63 ?gen1117 ?gen1118 ?gen1119 $$$ $?gen1122 ) ) ) ) ) ( test ( eq ( class ?gen1120 ) crime_art156_2 ) ) => ( calc ( bind $?gen1125 ( create$ rule63 ?gen1117 ?gen1118 ?gen1119 $?gen1122 ) ) ) ?gen1120 <- ( crime_art156_2 ( positive-support $?gen1125 ) )"))

([rule62-defeasibly-dot] of derived-attribute-rule
   (pos-name rule62-defeasibly-dot-gen1558)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule62] ) ) ) ?gen1107 <- ( crime_art156 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule62 $? ) ) ( test ( eq ( class ?gen1107 ) crime_art156 ) ) ( not ( and ?gen1114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1113 & : ( >= ?gen1113 1 ) ) ) ?gen1116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1115 & : ( >= ?gen1115 1 ) ) ) ?gen1107 <- ( crime_art156 ( negative ~ 2 ) ( positive-overruled $?gen1109 & : ( not ( member$ rule62 $?gen1109 ) ) ) ) ) ) => ?gen1107 <- ( crime_art156 ( positive 0 ) )"))

([rule62-defeasibly] of derived-attribute-rule
   (pos-name rule62-defeasibly-gen1560)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule62] ) ) ) ?gen1114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1113 & : ( >= ?gen1113 1 ) ) ) ?gen1116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1115 & : ( >= ?gen1115 1 ) ) ) ?gen1107 <- ( crime_art156 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1109 & : ( not ( member$ rule62 $?gen1109 ) ) ) ) ( test ( eq ( class ?gen1107 ) crime_art156 ) ) => ?gen1107 <- ( crime_art156 ( positive 1 ) ( positive-derivator rule62 ?gen1114 ?gen1116 ) )"))

([rule62-overruled-dot] of derived-attribute-rule
   (pos-name rule62-overruled-dot-gen1562)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule62] ) ) ) ?gen1107 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen1110 ) ( negative-overruled $?gen1111 & : ( subseq-pos ( create$ rule62-overruled $?gen1110 $$$ $?gen1111 ) ) ) ) ( test ( eq ( class ?gen1107 ) crime_art156 ) ) ( not ( and ?gen1114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1113 & : ( >= ?gen1113 1 ) ) ) ?gen1116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1115 & : ( >= ?gen1115 1 ) ) ) ?gen1107 <- ( crime_art156 ( positive-defeated $?gen1109 & : ( not ( member$ rule62 $?gen1109 ) ) ) ) ) ) => ( calc ( bind $?gen1112 ( delete-member$ $?gen1111 ( create$ rule62-overruled $?gen1110 ) ) ) ) ?gen1107 <- ( crime_art156 ( negative-overruled $?gen1112 ) )"))

([rule62-overruled] of derived-attribute-rule
   (pos-name rule62-overruled-gen1564)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule62] ) ) ) ?gen1114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1113 & : ( >= ?gen1113 1 ) ) ) ?gen1116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ( positive ?gen1115 & : ( >= ?gen1115 1 ) ) ) ?gen1107 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen1110 ) ( negative-overruled $?gen1111 & : ( not ( subseq-pos ( create$ rule62-overruled $?gen1110 $$$ $?gen1111 ) ) ) ) ( positive-defeated $?gen1109 & : ( not ( member$ rule62 $?gen1109 ) ) ) ) ( test ( eq ( class ?gen1107 ) crime_art156 ) ) => ( calc ( bind $?gen1112 ( create$ rule62-overruled $?gen1110 $?gen1111 ) ) ) ?gen1107 <- ( crime_art156 ( negative-overruled $?gen1112 ) )"))

([rule62-support] of derived-attribute-rule
   (pos-name rule62-support-gen1566)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule62] ) ) ) ?gen1105 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1106 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen1107 <- ( crime_art156 ( defendant ?Defendant ) ( positive-support $?gen1109 & : ( not ( subseq-pos ( create$ rule62 ?gen1105 ?gen1106 $$$ $?gen1109 ) ) ) ) ) ( test ( eq ( class ?gen1107 ) crime_art156 ) ) => ( calc ( bind $?gen1112 ( create$ rule62 ?gen1105 ?gen1106 $?gen1109 ) ) ) ?gen1107 <- ( crime_art156 ( positive-support $?gen1112 ) )"))

([rule61-defeasibly-dot] of derived-attribute-rule
   (pos-name rule61-defeasibly-dot-gen1568)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule61] ) ) ) ?gen1095 <- ( crime_art156 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule61 $? ) ) ( test ( eq ( class ?gen1095 ) crime_art156 ) ) ( not ( and ?gen1102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1101 & : ( >= ?gen1101 1 ) ) ) ?gen1104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1103 & : ( >= ?gen1103 1 ) ) ) ?gen1095 <- ( crime_art156 ( negative ~ 2 ) ( positive-overruled $?gen1097 & : ( not ( member$ rule61 $?gen1097 ) ) ) ) ) ) => ?gen1095 <- ( crime_art156 ( positive 0 ) )"))

([rule61-defeasibly] of derived-attribute-rule
   (pos-name rule61-defeasibly-gen1570)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule61] ) ) ) ?gen1102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1101 & : ( >= ?gen1101 1 ) ) ) ?gen1104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1103 & : ( >= ?gen1103 1 ) ) ) ?gen1095 <- ( crime_art156 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1097 & : ( not ( member$ rule61 $?gen1097 ) ) ) ) ( test ( eq ( class ?gen1095 ) crime_art156 ) ) => ?gen1095 <- ( crime_art156 ( positive 1 ) ( positive-derivator rule61 ?gen1102 ?gen1104 ) )"))

([rule61-overruled-dot] of derived-attribute-rule
   (pos-name rule61-overruled-dot-gen1572)
   (depends-on declare crime_art156 lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule61] ) ) ) ?gen1095 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen1098 ) ( negative-overruled $?gen1099 & : ( subseq-pos ( create$ rule61-overruled $?gen1098 $$$ $?gen1099 ) ) ) ) ( test ( eq ( class ?gen1095 ) crime_art156 ) ) ( not ( and ?gen1102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1101 & : ( >= ?gen1101 1 ) ) ) ?gen1104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1103 & : ( >= ?gen1103 1 ) ) ) ?gen1095 <- ( crime_art156 ( positive-defeated $?gen1097 & : ( not ( member$ rule61 $?gen1097 ) ) ) ) ) ) => ( calc ( bind $?gen1100 ( delete-member$ $?gen1099 ( create$ rule61-overruled $?gen1098 ) ) ) ) ?gen1095 <- ( crime_art156 ( negative-overruled $?gen1100 ) )"))

([rule61-overruled] of derived-attribute-rule
   (pos-name rule61-overruled-gen1574)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule61] ) ) ) ?gen1102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1101 & : ( >= ?gen1101 1 ) ) ) ?gen1104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ( positive ?gen1103 & : ( >= ?gen1103 1 ) ) ) ?gen1095 <- ( crime_art156 ( defendant ?Defendant ) ( negative-support $?gen1098 ) ( negative-overruled $?gen1099 & : ( not ( subseq-pos ( create$ rule61-overruled $?gen1098 $$$ $?gen1099 ) ) ) ) ( positive-defeated $?gen1097 & : ( not ( member$ rule61 $?gen1097 ) ) ) ) ( test ( eq ( class ?gen1095 ) crime_art156 ) ) => ( calc ( bind $?gen1100 ( create$ rule61-overruled $?gen1098 $?gen1099 ) ) ) ?gen1095 <- ( crime_art156 ( negative-overruled $?gen1100 ) )"))

([rule61-support] of derived-attribute-rule
   (pos-name rule61-support-gen1576)
   (depends-on declare lc:case lc:case crime_art156)
   (implies crime_art156)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule61] ) ) ) ?gen1093 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1094 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen1095 <- ( crime_art156 ( defendant ?Defendant ) ( positive-support $?gen1097 & : ( not ( subseq-pos ( create$ rule61 ?gen1093 ?gen1094 $$$ $?gen1097 ) ) ) ) ) ( test ( eq ( class ?gen1095 ) crime_art156 ) ) => ( calc ( bind $?gen1100 ( create$ rule61 ?gen1093 ?gen1094 $?gen1097 ) ) ) ?gen1095 <- ( crime_art156 ( positive-support $?gen1100 ) )"))

([rule60-defeasibly-dot] of derived-attribute-rule
   (pos-name rule60-defeasibly-dot-gen1578)
   (depends-on declare crime_art155_3 or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule60] ) ) ) ?gen1079 <- ( crime_art155_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule60 $? ) ) ( test ( eq ( class ?gen1079 ) crime_art155_3 ) ) ( not ( and ?gen1086 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1085 & : ( >= ?gen1085 1 ) ) ) ?gen1088 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1087 & : ( >= ?gen1087 1 ) ) ) ?gen1090 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1089 & : ( >= ?gen1089 1 ) ) ) ?gen1092 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1091 & : ( >= ?gen1091 1 ) ) ) ?gen1079 <- ( crime_art155_3 ( negative ~ 2 ) ( positive-overruled $?gen1081 & : ( not ( member$ rule60 $?gen1081 ) ) ) ) ) ) => ?gen1079 <- ( crime_art155_3 ( positive 0 ) )"))

([rule60-defeasibly] of derived-attribute-rule
   (pos-name rule60-defeasibly-gen1580)
   (depends-on declare or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule60] ) ) ) ?gen1086 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1085 & : ( >= ?gen1085 1 ) ) ) ?gen1088 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1087 & : ( >= ?gen1087 1 ) ) ) ?gen1090 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1089 & : ( >= ?gen1089 1 ) ) ) ?gen1092 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1091 & : ( >= ?gen1091 1 ) ) ) ?gen1079 <- ( crime_art155_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1081 & : ( not ( member$ rule60 $?gen1081 ) ) ) ) ( test ( eq ( class ?gen1079 ) crime_art155_3 ) ) => ?gen1079 <- ( crime_art155_3 ( positive 1 ) ( positive-derivator rule60 ?gen1086 ?gen1088 ?gen1090 ?gen1092 ) )"))

([rule60-overruled-dot] of derived-attribute-rule
   (pos-name rule60-overruled-dot-gen1582)
   (depends-on declare crime_art155_3 or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule60] ) ) ) ?gen1079 <- ( crime_art155_3 ( defendant ?Defendant ) ( negative-support $?gen1082 ) ( negative-overruled $?gen1083 & : ( subseq-pos ( create$ rule60-overruled $?gen1082 $$$ $?gen1083 ) ) ) ) ( test ( eq ( class ?gen1079 ) crime_art155_3 ) ) ( not ( and ?gen1086 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1085 & : ( >= ?gen1085 1 ) ) ) ?gen1088 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1087 & : ( >= ?gen1087 1 ) ) ) ?gen1090 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1089 & : ( >= ?gen1089 1 ) ) ) ?gen1092 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1091 & : ( >= ?gen1091 1 ) ) ) ?gen1079 <- ( crime_art155_3 ( positive-defeated $?gen1081 & : ( not ( member$ rule60 $?gen1081 ) ) ) ) ) ) => ( calc ( bind $?gen1084 ( delete-member$ $?gen1083 ( create$ rule60-overruled $?gen1082 ) ) ) ) ?gen1079 <- ( crime_art155_3 ( negative-overruled $?gen1084 ) )"))

([rule60-overruled] of derived-attribute-rule
   (pos-name rule60-overruled-gen1584)
   (depends-on declare or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule60] ) ) ) ?gen1086 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1085 & : ( >= ?gen1085 1 ) ) ) ?gen1088 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1087 & : ( >= ?gen1087 1 ) ) ) ?gen1090 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1089 & : ( >= ?gen1089 1 ) ) ) ?gen1092 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ( positive ?gen1091 & : ( >= ?gen1091 1 ) ) ) ?gen1079 <- ( crime_art155_3 ( defendant ?Defendant ) ( negative-support $?gen1082 ) ( negative-overruled $?gen1083 & : ( not ( subseq-pos ( create$ rule60-overruled $?gen1082 $$$ $?gen1083 ) ) ) ) ( positive-defeated $?gen1081 & : ( not ( member$ rule60 $?gen1081 ) ) ) ) ( test ( eq ( class ?gen1079 ) crime_art155_3 ) ) => ( calc ( bind $?gen1084 ( create$ rule60-overruled $?gen1082 $?gen1083 ) ) ) ?gen1079 <- ( crime_art155_3 ( negative-overruled $?gen1084 ) )"))

([rule60-support] of derived-attribute-rule
   (pos-name rule60-support-gen1586)
   (depends-on declare or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule60] ) ) ) ?gen1075 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ?gen1076 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1077 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1078 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ?gen1079 <- ( crime_art155_3 ( defendant ?Defendant ) ( positive-support $?gen1081 & : ( not ( subseq-pos ( create$ rule60 ?gen1075 ?gen1076 ?gen1077 ?gen1078 $$$ $?gen1081 ) ) ) ) ) ( test ( eq ( class ?gen1079 ) crime_art155_3 ) ) => ( calc ( bind $?gen1084 ( create$ rule60 ?gen1075 ?gen1076 ?gen1077 ?gen1078 $?gen1081 ) ) ) ?gen1079 <- ( crime_art155_3 ( positive-support $?gen1084 ) )"))

([rule59-defeasibly-dot] of derived-attribute-rule
   (pos-name rule59-defeasibly-dot-gen1588)
   (depends-on declare crime_art155_2 or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule59] ) ) ) ?gen1061 <- ( crime_art155_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule59 $? ) ) ( test ( eq ( class ?gen1061 ) crime_art155_2 ) ) ( not ( and ?gen1068 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( positive ?gen1067 & : ( >= ?gen1067 1 ) ) ) ?gen1070 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1069 & : ( >= ?gen1069 1 ) ) ) ?gen1072 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1071 & : ( >= ?gen1071 1 ) ) ) ?gen1074 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ( positive ?gen1073 & : ( >= ?gen1073 1 ) ) ) ?gen1061 <- ( crime_art155_2 ( negative ~ 2 ) ( positive-overruled $?gen1063 & : ( not ( member$ rule59 $?gen1063 ) ) ) ) ) ) => ?gen1061 <- ( crime_art155_2 ( positive 0 ) )"))

([rule59-defeasibly] of derived-attribute-rule
   (pos-name rule59-defeasibly-gen1590)
   (depends-on declare or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule59] ) ) ) ?gen1068 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( positive ?gen1067 & : ( >= ?gen1067 1 ) ) ) ?gen1070 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1069 & : ( >= ?gen1069 1 ) ) ) ?gen1072 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1071 & : ( >= ?gen1071 1 ) ) ) ?gen1074 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ( positive ?gen1073 & : ( >= ?gen1073 1 ) ) ) ?gen1061 <- ( crime_art155_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1063 & : ( not ( member$ rule59 $?gen1063 ) ) ) ) ( test ( eq ( class ?gen1061 ) crime_art155_2 ) ) => ?gen1061 <- ( crime_art155_2 ( positive 1 ) ( positive-derivator rule59 ?gen1068 ?gen1070 ?gen1072 ?gen1074 ) )"))

([rule59-overruled-dot] of derived-attribute-rule
   (pos-name rule59-overruled-dot-gen1592)
   (depends-on declare crime_art155_2 or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule59] ) ) ) ?gen1061 <- ( crime_art155_2 ( defendant ?Defendant ) ( negative-support $?gen1064 ) ( negative-overruled $?gen1065 & : ( subseq-pos ( create$ rule59-overruled $?gen1064 $$$ $?gen1065 ) ) ) ) ( test ( eq ( class ?gen1061 ) crime_art155_2 ) ) ( not ( and ?gen1068 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( positive ?gen1067 & : ( >= ?gen1067 1 ) ) ) ?gen1070 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1069 & : ( >= ?gen1069 1 ) ) ) ?gen1072 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1071 & : ( >= ?gen1071 1 ) ) ) ?gen1074 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ( positive ?gen1073 & : ( >= ?gen1073 1 ) ) ) ?gen1061 <- ( crime_art155_2 ( positive-defeated $?gen1063 & : ( not ( member$ rule59 $?gen1063 ) ) ) ) ) ) => ( calc ( bind $?gen1066 ( delete-member$ $?gen1065 ( create$ rule59-overruled $?gen1064 ) ) ) ) ?gen1061 <- ( crime_art155_2 ( negative-overruled $?gen1066 ) )"))

([rule59-overruled] of derived-attribute-rule
   (pos-name rule59-overruled-gen1594)
   (depends-on declare or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule59] ) ) ) ?gen1068 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( positive ?gen1067 & : ( >= ?gen1067 1 ) ) ) ?gen1070 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1069 & : ( >= ?gen1069 1 ) ) ) ?gen1072 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1071 & : ( >= ?gen1071 1 ) ) ) ?gen1074 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ( positive ?gen1073 & : ( >= ?gen1073 1 ) ) ) ?gen1061 <- ( crime_art155_2 ( defendant ?Defendant ) ( negative-support $?gen1064 ) ( negative-overruled $?gen1065 & : ( not ( subseq-pos ( create$ rule59-overruled $?gen1064 $$$ $?gen1065 ) ) ) ) ( positive-defeated $?gen1063 & : ( not ( member$ rule59 $?gen1063 ) ) ) ) ( test ( eq ( class ?gen1061 ) crime_art155_2 ) ) => ( calc ( bind $?gen1066 ( create$ rule59-overruled $?gen1064 $?gen1065 ) ) ) ?gen1061 <- ( crime_art155_2 ( negative-overruled $?gen1066 ) )"))

([rule59-support] of derived-attribute-rule
   (pos-name rule59-support-gen1596)
   (depends-on declare or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule59] ) ) ) ?gen1057 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ) ?gen1058 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1059 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1060 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ) ?gen1061 <- ( crime_art155_2 ( defendant ?Defendant ) ( positive-support $?gen1063 & : ( not ( subseq-pos ( create$ rule59 ?gen1057 ?gen1058 ?gen1059 ?gen1060 $$$ $?gen1063 ) ) ) ) ) ( test ( eq ( class ?gen1061 ) crime_art155_2 ) ) => ( calc ( bind $?gen1066 ( create$ rule59 ?gen1057 ?gen1058 ?gen1059 ?gen1060 $?gen1063 ) ) ) ?gen1061 <- ( crime_art155_2 ( positive-support $?gen1066 ) )"))

([rule58-defeasibly-dot] of derived-attribute-rule
   (pos-name rule58-defeasibly-dot-gen1598)
   (depends-on declare crime_art155_1 lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule58] ) ) ) ?gen1045 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule58 $? ) ) ( test ( eq ( class ?gen1045 ) crime_art155_1 ) ) ( not ( and ?gen1052 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1051 & : ( >= ?gen1051 1 ) ) ) ?gen1054 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1053 & : ( >= ?gen1053 1 ) ) ) ?gen1056 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1055 & : ( >= ?gen1055 1 ) ) ) ?gen1045 <- ( crime_art155_1 ( negative ~ 2 ) ( positive-overruled $?gen1047 & : ( not ( member$ rule58 $?gen1047 ) ) ) ) ) ) => ?gen1045 <- ( crime_art155_1 ( positive 0 ) )"))

([rule58-defeasibly] of derived-attribute-rule
   (pos-name rule58-defeasibly-gen1600)
   (depends-on declare lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule58] ) ) ) ?gen1052 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1051 & : ( >= ?gen1051 1 ) ) ) ?gen1054 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1053 & : ( >= ?gen1053 1 ) ) ) ?gen1056 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1055 & : ( >= ?gen1055 1 ) ) ) ?gen1045 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1047 & : ( not ( member$ rule58 $?gen1047 ) ) ) ) ( test ( eq ( class ?gen1045 ) crime_art155_1 ) ) => ?gen1045 <- ( crime_art155_1 ( positive 1 ) ( positive-derivator rule58 ?gen1052 ?gen1054 ?gen1056 ) )"))

([rule58-overruled-dot] of derived-attribute-rule
   (pos-name rule58-overruled-dot-gen1602)
   (depends-on declare crime_art155_1 lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule58] ) ) ) ?gen1045 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen1048 ) ( negative-overruled $?gen1049 & : ( subseq-pos ( create$ rule58-overruled $?gen1048 $$$ $?gen1049 ) ) ) ) ( test ( eq ( class ?gen1045 ) crime_art155_1 ) ) ( not ( and ?gen1052 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1051 & : ( >= ?gen1051 1 ) ) ) ?gen1054 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1053 & : ( >= ?gen1053 1 ) ) ) ?gen1056 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1055 & : ( >= ?gen1055 1 ) ) ) ?gen1045 <- ( crime_art155_1 ( positive-defeated $?gen1047 & : ( not ( member$ rule58 $?gen1047 ) ) ) ) ) ) => ( calc ( bind $?gen1050 ( delete-member$ $?gen1049 ( create$ rule58-overruled $?gen1048 ) ) ) ) ?gen1045 <- ( crime_art155_1 ( negative-overruled $?gen1050 ) )"))

([rule58-overruled] of derived-attribute-rule
   (pos-name rule58-overruled-gen1604)
   (depends-on declare lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule58] ) ) ) ?gen1052 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ( positive ?gen1051 & : ( >= ?gen1051 1 ) ) ) ?gen1054 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ( positive ?gen1053 & : ( >= ?gen1053 1 ) ) ) ?gen1056 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( positive ?gen1055 & : ( >= ?gen1055 1 ) ) ) ?gen1045 <- ( crime_art155_1 ( defendant ?Defendant ) ( negative-support $?gen1048 ) ( negative-overruled $?gen1049 & : ( not ( subseq-pos ( create$ rule58-overruled $?gen1048 $$$ $?gen1049 ) ) ) ) ( positive-defeated $?gen1047 & : ( not ( member$ rule58 $?gen1047 ) ) ) ) ( test ( eq ( class ?gen1045 ) crime_art155_1 ) ) => ( calc ( bind $?gen1050 ( create$ rule58-overruled $?gen1048 $?gen1049 ) ) ) ?gen1045 <- ( crime_art155_1 ( negative-overruled $?gen1050 ) )"))

([rule58-support] of derived-attribute-rule
   (pos-name rule58-support-gen1606)
   (depends-on declare lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule58] ) ) ) ?gen1042 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1043 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1044 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ?gen1045 <- ( crime_art155_1 ( defendant ?Defendant ) ( positive-support $?gen1047 & : ( not ( subseq-pos ( create$ rule58 ?gen1042 ?gen1043 ?gen1044 $$$ $?gen1047 ) ) ) ) ) ( test ( eq ( class ?gen1045 ) crime_art155_1 ) ) => ( calc ( bind $?gen1050 ( create$ rule58 ?gen1042 ?gen1043 ?gen1044 $?gen1047 ) ) ) ?gen1045 <- ( crime_art155_1 ( positive-support $?gen1050 ) )"))

([rule57b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule57b-defeasibly-dot-gen1608)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule57b] ) ) ) ?gen1032 <- ( crime_art154 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule57b $? ) ) ( test ( eq ( class ?gen1032 ) crime_art154 ) ) ( not ( and ?gen1039 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1038 & : ( >= ?gen1038 1 ) ) ) ?gen1041 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen1040 & : ( >= ?gen1040 1 ) ) ) ?gen1032 <- ( crime_art154 ( negative ~ 2 ) ( positive-overruled $?gen1034 & : ( not ( member$ rule57b $?gen1034 ) ) ) ) ) ) => ?gen1032 <- ( crime_art154 ( positive 0 ) )"))

([rule57b-defeasibly] of derived-attribute-rule
   (pos-name rule57b-defeasibly-gen1610)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule57b] ) ) ) ?gen1039 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1038 & : ( >= ?gen1038 1 ) ) ) ?gen1041 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen1040 & : ( >= ?gen1040 1 ) ) ) ?gen1032 <- ( crime_art154 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1034 & : ( not ( member$ rule57b $?gen1034 ) ) ) ) ( test ( eq ( class ?gen1032 ) crime_art154 ) ) => ?gen1032 <- ( crime_art154 ( positive 1 ) ( positive-derivator rule57b ?gen1039 ?gen1041 ) )"))

([rule57b-overruled-dot] of derived-attribute-rule
   (pos-name rule57b-overruled-dot-gen1612)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule57b] ) ) ) ?gen1032 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1035 ) ( negative-overruled $?gen1036 & : ( subseq-pos ( create$ rule57b-overruled $?gen1035 $$$ $?gen1036 ) ) ) ) ( test ( eq ( class ?gen1032 ) crime_art154 ) ) ( not ( and ?gen1039 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1038 & : ( >= ?gen1038 1 ) ) ) ?gen1041 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen1040 & : ( >= ?gen1040 1 ) ) ) ?gen1032 <- ( crime_art154 ( positive-defeated $?gen1034 & : ( not ( member$ rule57b $?gen1034 ) ) ) ) ) ) => ( calc ( bind $?gen1037 ( delete-member$ $?gen1036 ( create$ rule57b-overruled $?gen1035 ) ) ) ) ?gen1032 <- ( crime_art154 ( negative-overruled $?gen1037 ) )"))

([rule57b-overruled] of derived-attribute-rule
   (pos-name rule57b-overruled-gen1614)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule57b] ) ) ) ?gen1039 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1038 & : ( >= ?gen1038 1 ) ) ) ?gen1041 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen1040 & : ( >= ?gen1040 1 ) ) ) ?gen1032 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1035 ) ( negative-overruled $?gen1036 & : ( not ( subseq-pos ( create$ rule57b-overruled $?gen1035 $$$ $?gen1036 ) ) ) ) ( positive-defeated $?gen1034 & : ( not ( member$ rule57b $?gen1034 ) ) ) ) ( test ( eq ( class ?gen1032 ) crime_art154 ) ) => ( calc ( bind $?gen1037 ( create$ rule57b-overruled $?gen1035 $?gen1036 ) ) ) ?gen1032 <- ( crime_art154 ( negative-overruled $?gen1037 ) )"))

([rule57b-support] of derived-attribute-rule
   (pos-name rule57b-support-gen1616)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule57b] ) ) ) ?gen1030 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1031 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ?gen1032 <- ( crime_art154 ( defendant ?Defendant ) ( positive-support $?gen1034 & : ( not ( subseq-pos ( create$ rule57b ?gen1030 ?gen1031 $$$ $?gen1034 ) ) ) ) ) ( test ( eq ( class ?gen1032 ) crime_art154 ) ) => ( calc ( bind $?gen1037 ( create$ rule57b ?gen1030 ?gen1031 $?gen1034 ) ) ) ?gen1032 <- ( crime_art154 ( positive-support $?gen1037 ) )"))

([rule57-defeasibly-dot] of derived-attribute-rule
   (pos-name rule57-defeasibly-dot-gen1618)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule57] ) ) ) ?gen1020 <- ( crime_art154 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule57 $? ) ) ( test ( eq ( class ?gen1020 ) crime_art154 ) ) ( not ( and ?gen1027 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1026 & : ( >= ?gen1026 1 ) ) ) ?gen1029 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen1028 & : ( >= ?gen1028 1 ) ) ) ?gen1020 <- ( crime_art154 ( negative ~ 2 ) ( positive-overruled $?gen1022 & : ( not ( member$ rule57 $?gen1022 ) ) ) ) ) ) => ?gen1020 <- ( crime_art154 ( positive 0 ) )"))

([rule57-defeasibly] of derived-attribute-rule
   (pos-name rule57-defeasibly-gen1620)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule57] ) ) ) ?gen1027 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1026 & : ( >= ?gen1026 1 ) ) ) ?gen1029 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen1028 & : ( >= ?gen1028 1 ) ) ) ?gen1020 <- ( crime_art154 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1022 & : ( not ( member$ rule57 $?gen1022 ) ) ) ) ( test ( eq ( class ?gen1020 ) crime_art154 ) ) => ?gen1020 <- ( crime_art154 ( positive 1 ) ( positive-derivator rule57 ?gen1027 ?gen1029 ) )"))

([rule57-overruled-dot] of derived-attribute-rule
   (pos-name rule57-overruled-dot-gen1622)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule57] ) ) ) ?gen1020 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1023 ) ( negative-overruled $?gen1024 & : ( subseq-pos ( create$ rule57-overruled $?gen1023 $$$ $?gen1024 ) ) ) ) ( test ( eq ( class ?gen1020 ) crime_art154 ) ) ( not ( and ?gen1027 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1026 & : ( >= ?gen1026 1 ) ) ) ?gen1029 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen1028 & : ( >= ?gen1028 1 ) ) ) ?gen1020 <- ( crime_art154 ( positive-defeated $?gen1022 & : ( not ( member$ rule57 $?gen1022 ) ) ) ) ) ) => ( calc ( bind $?gen1025 ( delete-member$ $?gen1024 ( create$ rule57-overruled $?gen1023 ) ) ) ) ?gen1020 <- ( crime_art154 ( negative-overruled $?gen1025 ) )"))

([rule57-overruled] of derived-attribute-rule
   (pos-name rule57-overruled-gen1624)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule57] ) ) ) ?gen1027 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1026 & : ( >= ?gen1026 1 ) ) ) ?gen1029 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen1028 & : ( >= ?gen1028 1 ) ) ) ?gen1020 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1023 ) ( negative-overruled $?gen1024 & : ( not ( subseq-pos ( create$ rule57-overruled $?gen1023 $$$ $?gen1024 ) ) ) ) ( positive-defeated $?gen1022 & : ( not ( member$ rule57 $?gen1022 ) ) ) ) ( test ( eq ( class ?gen1020 ) crime_art154 ) ) => ( calc ( bind $?gen1025 ( create$ rule57-overruled $?gen1023 $?gen1024 ) ) ) ?gen1020 <- ( crime_art154 ( negative-overruled $?gen1025 ) )"))

([rule57-support] of derived-attribute-rule
   (pos-name rule57-support-gen1626)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule57] ) ) ) ?gen1018 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1019 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ?gen1020 <- ( crime_art154 ( defendant ?Defendant ) ( positive-support $?gen1022 & : ( not ( subseq-pos ( create$ rule57 ?gen1018 ?gen1019 $$$ $?gen1022 ) ) ) ) ) ( test ( eq ( class ?gen1020 ) crime_art154 ) ) => ( calc ( bind $?gen1025 ( create$ rule57 ?gen1018 ?gen1019 $?gen1022 ) ) ) ?gen1020 <- ( crime_art154 ( positive-support $?gen1025 ) )"))

([rule56-defeasibly-dot] of derived-attribute-rule
   (pos-name rule56-defeasibly-dot-gen1628)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule56] ) ) ) ?gen1008 <- ( crime_art154 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule56 $? ) ) ( test ( eq ( class ?gen1008 ) crime_art154 ) ) ( not ( and ?gen1015 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1014 & : ( >= ?gen1014 1 ) ) ) ?gen1017 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen1016 & : ( >= ?gen1016 1 ) ) ) ?gen1008 <- ( crime_art154 ( negative ~ 2 ) ( positive-overruled $?gen1010 & : ( not ( member$ rule56 $?gen1010 ) ) ) ) ) ) => ?gen1008 <- ( crime_art154 ( positive 0 ) )"))

([rule56-defeasibly] of derived-attribute-rule
   (pos-name rule56-defeasibly-gen1630)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule56] ) ) ) ?gen1015 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1014 & : ( >= ?gen1014 1 ) ) ) ?gen1017 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen1016 & : ( >= ?gen1016 1 ) ) ) ?gen1008 <- ( crime_art154 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen1010 & : ( not ( member$ rule56 $?gen1010 ) ) ) ) ( test ( eq ( class ?gen1008 ) crime_art154 ) ) => ?gen1008 <- ( crime_art154 ( positive 1 ) ( positive-derivator rule56 ?gen1015 ?gen1017 ) )"))

([rule56-overruled-dot] of derived-attribute-rule
   (pos-name rule56-overruled-dot-gen1632)
   (depends-on declare crime_art154 lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule56] ) ) ) ?gen1008 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1011 ) ( negative-overruled $?gen1012 & : ( subseq-pos ( create$ rule56-overruled $?gen1011 $$$ $?gen1012 ) ) ) ) ( test ( eq ( class ?gen1008 ) crime_art154 ) ) ( not ( and ?gen1015 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1014 & : ( >= ?gen1014 1 ) ) ) ?gen1017 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen1016 & : ( >= ?gen1016 1 ) ) ) ?gen1008 <- ( crime_art154 ( positive-defeated $?gen1010 & : ( not ( member$ rule56 $?gen1010 ) ) ) ) ) ) => ( calc ( bind $?gen1013 ( delete-member$ $?gen1012 ( create$ rule56-overruled $?gen1011 ) ) ) ) ?gen1008 <- ( crime_art154 ( negative-overruled $?gen1013 ) )"))

([rule56-overruled] of derived-attribute-rule
   (pos-name rule56-overruled-gen1634)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule56] ) ) ) ?gen1015 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1014 & : ( >= ?gen1014 1 ) ) ) ?gen1017 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen1016 & : ( >= ?gen1016 1 ) ) ) ?gen1008 <- ( crime_art154 ( defendant ?Defendant ) ( negative-support $?gen1011 ) ( negative-overruled $?gen1012 & : ( not ( subseq-pos ( create$ rule56-overruled $?gen1011 $$$ $?gen1012 ) ) ) ) ( positive-defeated $?gen1010 & : ( not ( member$ rule56 $?gen1010 ) ) ) ) ( test ( eq ( class ?gen1008 ) crime_art154 ) ) => ( calc ( bind $?gen1013 ( create$ rule56-overruled $?gen1011 $?gen1012 ) ) ) ?gen1008 <- ( crime_art154 ( negative-overruled $?gen1013 ) )"))

([rule56-support] of derived-attribute-rule
   (pos-name rule56-support-gen1636)
   (depends-on declare lc:case lc:case crime_art154)
   (implies crime_art154)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule56] ) ) ) ?gen1006 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1007 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen1008 <- ( crime_art154 ( defendant ?Defendant ) ( positive-support $?gen1010 & : ( not ( subseq-pos ( create$ rule56 ?gen1006 ?gen1007 $$$ $?gen1010 ) ) ) ) ) ( test ( eq ( class ?gen1008 ) crime_art154 ) ) => ( calc ( bind $?gen1013 ( create$ rule56 ?gen1006 ?gen1007 $?gen1010 ) ) ) ?gen1008 <- ( crime_art154 ( positive-support $?gen1013 ) )"))

([rule55-defeasibly-dot] of derived-attribute-rule
   (pos-name rule55-defeasibly-dot-gen1638)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule55] ) ) ) ?gen996 <- ( crime_art153 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule55 $? ) ) ( test ( eq ( class ?gen996 ) crime_art153 ) ) ( not ( and ?gen1003 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1002 & : ( >= ?gen1002 1 ) ) ) ?gen1005 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen1004 & : ( >= ?gen1004 1 ) ) ) ?gen996 <- ( crime_art153 ( negative ~ 2 ) ( positive-overruled $?gen998 & : ( not ( member$ rule55 $?gen998 ) ) ) ) ) ) => ?gen996 <- ( crime_art153 ( positive 0 ) )"))

([rule55-defeasibly] of derived-attribute-rule
   (pos-name rule55-defeasibly-gen1640)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule55] ) ) ) ?gen1003 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1002 & : ( >= ?gen1002 1 ) ) ) ?gen1005 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen1004 & : ( >= ?gen1004 1 ) ) ) ?gen996 <- ( crime_art153 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen998 & : ( not ( member$ rule55 $?gen998 ) ) ) ) ( test ( eq ( class ?gen996 ) crime_art153 ) ) => ?gen996 <- ( crime_art153 ( positive 1 ) ( positive-derivator rule55 ?gen1003 ?gen1005 ) )"))

([rule55-overruled-dot] of derived-attribute-rule
   (pos-name rule55-overruled-dot-gen1642)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule55] ) ) ) ?gen996 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen999 ) ( negative-overruled $?gen1000 & : ( subseq-pos ( create$ rule55-overruled $?gen999 $$$ $?gen1000 ) ) ) ) ( test ( eq ( class ?gen996 ) crime_art153 ) ) ( not ( and ?gen1003 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1002 & : ( >= ?gen1002 1 ) ) ) ?gen1005 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen1004 & : ( >= ?gen1004 1 ) ) ) ?gen996 <- ( crime_art153 ( positive-defeated $?gen998 & : ( not ( member$ rule55 $?gen998 ) ) ) ) ) ) => ( calc ( bind $?gen1001 ( delete-member$ $?gen1000 ( create$ rule55-overruled $?gen999 ) ) ) ) ?gen996 <- ( crime_art153 ( negative-overruled $?gen1001 ) )"))

([rule55-overruled] of derived-attribute-rule
   (pos-name rule55-overruled-gen1644)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule55] ) ) ) ?gen1003 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen1002 & : ( >= ?gen1002 1 ) ) ) ?gen1005 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen1004 & : ( >= ?gen1004 1 ) ) ) ?gen996 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen999 ) ( negative-overruled $?gen1000 & : ( not ( subseq-pos ( create$ rule55-overruled $?gen999 $$$ $?gen1000 ) ) ) ) ( positive-defeated $?gen998 & : ( not ( member$ rule55 $?gen998 ) ) ) ) ( test ( eq ( class ?gen996 ) crime_art153 ) ) => ( calc ( bind $?gen1001 ( create$ rule55-overruled $?gen999 $?gen1000 ) ) ) ?gen996 <- ( crime_art153 ( negative-overruled $?gen1001 ) )"))

([rule55-support] of derived-attribute-rule
   (pos-name rule55-support-gen1646)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule55] ) ) ) ?gen994 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen995 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen996 <- ( crime_art153 ( defendant ?Defendant ) ( positive-support $?gen998 & : ( not ( subseq-pos ( create$ rule55 ?gen994 ?gen995 $$$ $?gen998 ) ) ) ) ) ( test ( eq ( class ?gen996 ) crime_art153 ) ) => ( calc ( bind $?gen1001 ( create$ rule55 ?gen994 ?gen995 $?gen998 ) ) ) ?gen996 <- ( crime_art153 ( positive-support $?gen1001 ) )"))

([rule54-defeasibly-dot] of derived-attribute-rule
   (pos-name rule54-defeasibly-dot-gen1648)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule54] ) ) ) ?gen984 <- ( crime_art153 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule54 $? ) ) ( test ( eq ( class ?gen984 ) crime_art153 ) ) ( not ( and ?gen991 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen990 & : ( >= ?gen990 1 ) ) ) ?gen993 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen992 & : ( >= ?gen992 1 ) ) ) ?gen984 <- ( crime_art153 ( negative ~ 2 ) ( positive-overruled $?gen986 & : ( not ( member$ rule54 $?gen986 ) ) ) ) ) ) => ?gen984 <- ( crime_art153 ( positive 0 ) )"))

([rule54-defeasibly] of derived-attribute-rule
   (pos-name rule54-defeasibly-gen1650)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule54] ) ) ) ?gen991 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen990 & : ( >= ?gen990 1 ) ) ) ?gen993 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen992 & : ( >= ?gen992 1 ) ) ) ?gen984 <- ( crime_art153 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen986 & : ( not ( member$ rule54 $?gen986 ) ) ) ) ( test ( eq ( class ?gen984 ) crime_art153 ) ) => ?gen984 <- ( crime_art153 ( positive 1 ) ( positive-derivator rule54 ?gen991 ?gen993 ) )"))

([rule54-overruled-dot] of derived-attribute-rule
   (pos-name rule54-overruled-dot-gen1652)
   (depends-on declare crime_art153 lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule54] ) ) ) ?gen984 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen987 ) ( negative-overruled $?gen988 & : ( subseq-pos ( create$ rule54-overruled $?gen987 $$$ $?gen988 ) ) ) ) ( test ( eq ( class ?gen984 ) crime_art153 ) ) ( not ( and ?gen991 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen990 & : ( >= ?gen990 1 ) ) ) ?gen993 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen992 & : ( >= ?gen992 1 ) ) ) ?gen984 <- ( crime_art153 ( positive-defeated $?gen986 & : ( not ( member$ rule54 $?gen986 ) ) ) ) ) ) => ( calc ( bind $?gen989 ( delete-member$ $?gen988 ( create$ rule54-overruled $?gen987 ) ) ) ) ?gen984 <- ( crime_art153 ( negative-overruled $?gen989 ) )"))

([rule54-overruled] of derived-attribute-rule
   (pos-name rule54-overruled-gen1654)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule54] ) ) ) ?gen991 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ( positive ?gen990 & : ( >= ?gen990 1 ) ) ) ?gen993 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen992 & : ( >= ?gen992 1 ) ) ) ?gen984 <- ( crime_art153 ( defendant ?Defendant ) ( negative-support $?gen987 ) ( negative-overruled $?gen988 & : ( not ( subseq-pos ( create$ rule54-overruled $?gen987 $$$ $?gen988 ) ) ) ) ( positive-defeated $?gen986 & : ( not ( member$ rule54 $?gen986 ) ) ) ) ( test ( eq ( class ?gen984 ) crime_art153 ) ) => ( calc ( bind $?gen989 ( create$ rule54-overruled $?gen987 $?gen988 ) ) ) ?gen984 <- ( crime_art153 ( negative-overruled $?gen989 ) )"))

([rule54-support] of derived-attribute-rule
   (pos-name rule54-support-gen1656)
   (depends-on declare lc:case lc:case crime_art153)
   (implies crime_art153)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule54] ) ) ) ?gen982 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen983 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen984 <- ( crime_art153 ( defendant ?Defendant ) ( positive-support $?gen986 & : ( not ( subseq-pos ( create$ rule54 ?gen982 ?gen983 $$$ $?gen986 ) ) ) ) ) ( test ( eq ( class ?gen984 ) crime_art153 ) ) => ( calc ( bind $?gen989 ( create$ rule54 ?gen982 ?gen983 $?gen986 ) ) ) ?gen984 <- ( crime_art153 ( positive-support $?gen989 ) )"))

([rule53b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule53b-defeasibly-dot-gen1658)
   (depends-on declare crime_art152_3 lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule53b] ) ) ) ?gen970 <- ( crime_art152_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule53b $? ) ) ( test ( eq ( class ?gen970 ) crime_art152_3 ) ) ( not ( and ?gen977 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen976 & : ( >= ?gen976 1 ) ) ) ?gen979 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen978 & : ( >= ?gen978 1 ) ) ) ?gen981 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( positive ?gen980 & : ( >= ?gen980 1 ) ) ) ?gen970 <- ( crime_art152_3 ( negative ~ 2 ) ( positive-overruled $?gen972 & : ( not ( member$ rule53b $?gen972 ) ) ) ) ) ) => ?gen970 <- ( crime_art152_3 ( positive 0 ) )"))

([rule53b-defeasibly] of derived-attribute-rule
   (pos-name rule53b-defeasibly-gen1660)
   (depends-on declare lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule53b] ) ) ) ?gen977 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen976 & : ( >= ?gen976 1 ) ) ) ?gen979 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen978 & : ( >= ?gen978 1 ) ) ) ?gen981 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( positive ?gen980 & : ( >= ?gen980 1 ) ) ) ?gen970 <- ( crime_art152_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen972 & : ( not ( member$ rule53b $?gen972 ) ) ) ) ( test ( eq ( class ?gen970 ) crime_art152_3 ) ) => ?gen970 <- ( crime_art152_3 ( positive 1 ) ( positive-derivator rule53b ?gen977 ?gen979 ?gen981 ) )"))

([rule53b-overruled-dot] of derived-attribute-rule
   (pos-name rule53b-overruled-dot-gen1662)
   (depends-on declare crime_art152_3 lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule53b] ) ) ) ?gen970 <- ( crime_art152_3 ( defendant ?Defendant ) ( negative-support $?gen973 ) ( negative-overruled $?gen974 & : ( subseq-pos ( create$ rule53b-overruled $?gen973 $$$ $?gen974 ) ) ) ) ( test ( eq ( class ?gen970 ) crime_art152_3 ) ) ( not ( and ?gen977 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen976 & : ( >= ?gen976 1 ) ) ) ?gen979 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen978 & : ( >= ?gen978 1 ) ) ) ?gen981 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( positive ?gen980 & : ( >= ?gen980 1 ) ) ) ?gen970 <- ( crime_art152_3 ( positive-defeated $?gen972 & : ( not ( member$ rule53b $?gen972 ) ) ) ) ) ) => ( calc ( bind $?gen975 ( delete-member$ $?gen974 ( create$ rule53b-overruled $?gen973 ) ) ) ) ?gen970 <- ( crime_art152_3 ( negative-overruled $?gen975 ) )"))

([rule53b-overruled] of derived-attribute-rule
   (pos-name rule53b-overruled-gen1664)
   (depends-on declare lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule53b] ) ) ) ?gen977 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen976 & : ( >= ?gen976 1 ) ) ) ?gen979 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ( positive ?gen978 & : ( >= ?gen978 1 ) ) ) ?gen981 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( positive ?gen980 & : ( >= ?gen980 1 ) ) ) ?gen970 <- ( crime_art152_3 ( defendant ?Defendant ) ( negative-support $?gen973 ) ( negative-overruled $?gen974 & : ( not ( subseq-pos ( create$ rule53b-overruled $?gen973 $$$ $?gen974 ) ) ) ) ( positive-defeated $?gen972 & : ( not ( member$ rule53b $?gen972 ) ) ) ) ( test ( eq ( class ?gen970 ) crime_art152_3 ) ) => ( calc ( bind $?gen975 ( create$ rule53b-overruled $?gen973 $?gen974 ) ) ) ?gen970 <- ( crime_art152_3 ( negative-overruled $?gen975 ) )"))

([rule53b-support] of derived-attribute-rule
   (pos-name rule53b-support-gen1666)
   (depends-on declare lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule53b] ) ) ) ?gen967 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen968 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ?gen969 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ) ?gen970 <- ( crime_art152_3 ( defendant ?Defendant ) ( positive-support $?gen972 & : ( not ( subseq-pos ( create$ rule53b ?gen967 ?gen968 ?gen969 $$$ $?gen972 ) ) ) ) ) ( test ( eq ( class ?gen970 ) crime_art152_3 ) ) => ( calc ( bind $?gen975 ( create$ rule53b ?gen967 ?gen968 ?gen969 $?gen972 ) ) ) ?gen970 <- ( crime_art152_3 ( positive-support $?gen975 ) )"))

([rule53-defeasibly-dot] of derived-attribute-rule
   (pos-name rule53-defeasibly-dot-gen1668)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule53] ) ) ) ?gen957 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule53 $? ) ) ( test ( eq ( class ?gen957 ) crime_art152_2 ) ) ( not ( and ?gen964 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen963 & : ( >= ?gen963 1 ) ) ) ?gen966 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen965 & : ( >= ?gen965 1 ) ) ) ?gen957 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen959 & : ( not ( member$ rule53 $?gen959 ) ) ) ) ) ) => ?gen957 <- ( crime_art152_2 ( positive 0 ) )"))

([rule53-defeasibly] of derived-attribute-rule
   (pos-name rule53-defeasibly-gen1670)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule53] ) ) ) ?gen964 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen963 & : ( >= ?gen963 1 ) ) ) ?gen966 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen965 & : ( >= ?gen965 1 ) ) ) ?gen957 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen959 & : ( not ( member$ rule53 $?gen959 ) ) ) ) ( test ( eq ( class ?gen957 ) crime_art152_2 ) ) => ?gen957 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule53 ?gen964 ?gen966 ) )"))

([rule53-overruled-dot] of derived-attribute-rule
   (pos-name rule53-overruled-dot-gen1672)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule53] ) ) ) ?gen957 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen960 ) ( negative-overruled $?gen961 & : ( subseq-pos ( create$ rule53-overruled $?gen960 $$$ $?gen961 ) ) ) ) ( test ( eq ( class ?gen957 ) crime_art152_2 ) ) ( not ( and ?gen964 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen963 & : ( >= ?gen963 1 ) ) ) ?gen966 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen965 & : ( >= ?gen965 1 ) ) ) ?gen957 <- ( crime_art152_2 ( positive-defeated $?gen959 & : ( not ( member$ rule53 $?gen959 ) ) ) ) ) ) => ( calc ( bind $?gen962 ( delete-member$ $?gen961 ( create$ rule53-overruled $?gen960 ) ) ) ) ?gen957 <- ( crime_art152_2 ( negative-overruled $?gen962 ) )"))

([rule53-overruled] of derived-attribute-rule
   (pos-name rule53-overruled-gen1674)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule53] ) ) ) ?gen964 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ( positive ?gen963 & : ( >= ?gen963 1 ) ) ) ?gen966 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen965 & : ( >= ?gen965 1 ) ) ) ?gen957 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen960 ) ( negative-overruled $?gen961 & : ( not ( subseq-pos ( create$ rule53-overruled $?gen960 $$$ $?gen961 ) ) ) ) ( positive-defeated $?gen959 & : ( not ( member$ rule53 $?gen959 ) ) ) ) ( test ( eq ( class ?gen957 ) crime_art152_2 ) ) => ( calc ( bind $?gen962 ( create$ rule53-overruled $?gen960 $?gen961 ) ) ) ?gen957 <- ( crime_art152_2 ( negative-overruled $?gen962 ) )"))

([rule53-support] of derived-attribute-rule
   (pos-name rule53-support-gen1676)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule53] ) ) ) ?gen955 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ?gen956 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ?gen957 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen959 & : ( not ( subseq-pos ( create$ rule53 ?gen955 ?gen956 $$$ $?gen959 ) ) ) ) ) ( test ( eq ( class ?gen957 ) crime_art152_2 ) ) => ( calc ( bind $?gen962 ( create$ rule53 ?gen955 ?gen956 $?gen959 ) ) ) ?gen957 <- ( crime_art152_2 ( positive-support $?gen962 ) )"))

([rule52-defeasibly-dot] of derived-attribute-rule
   (pos-name rule52-defeasibly-dot-gen1678)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule52] ) ) ) ?gen945 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule52 $? ) ) ( test ( eq ( class ?gen945 ) crime_art152_2 ) ) ( not ( and ?gen952 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen951 & : ( >= ?gen951 1 ) ) ) ?gen954 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen953 & : ( >= ?gen953 1 ) ) ) ?gen945 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen947 & : ( not ( member$ rule52 $?gen947 ) ) ) ) ) ) => ?gen945 <- ( crime_art152_2 ( positive 0 ) )"))

([rule52-defeasibly] of derived-attribute-rule
   (pos-name rule52-defeasibly-gen1680)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule52] ) ) ) ?gen952 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen951 & : ( >= ?gen951 1 ) ) ) ?gen954 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen953 & : ( >= ?gen953 1 ) ) ) ?gen945 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen947 & : ( not ( member$ rule52 $?gen947 ) ) ) ) ( test ( eq ( class ?gen945 ) crime_art152_2 ) ) => ?gen945 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule52 ?gen952 ?gen954 ) )"))

([rule52-overruled-dot] of derived-attribute-rule
   (pos-name rule52-overruled-dot-gen1682)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule52] ) ) ) ?gen945 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen948 ) ( negative-overruled $?gen949 & : ( subseq-pos ( create$ rule52-overruled $?gen948 $$$ $?gen949 ) ) ) ) ( test ( eq ( class ?gen945 ) crime_art152_2 ) ) ( not ( and ?gen952 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen951 & : ( >= ?gen951 1 ) ) ) ?gen954 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen953 & : ( >= ?gen953 1 ) ) ) ?gen945 <- ( crime_art152_2 ( positive-defeated $?gen947 & : ( not ( member$ rule52 $?gen947 ) ) ) ) ) ) => ( calc ( bind $?gen950 ( delete-member$ $?gen949 ( create$ rule52-overruled $?gen948 ) ) ) ) ?gen945 <- ( crime_art152_2 ( negative-overruled $?gen950 ) )"))

([rule52-overruled] of derived-attribute-rule
   (pos-name rule52-overruled-gen1684)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule52] ) ) ) ?gen952 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ( positive ?gen951 & : ( >= ?gen951 1 ) ) ) ?gen954 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ( positive ?gen953 & : ( >= ?gen953 1 ) ) ) ?gen945 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen948 ) ( negative-overruled $?gen949 & : ( not ( subseq-pos ( create$ rule52-overruled $?gen948 $$$ $?gen949 ) ) ) ) ( positive-defeated $?gen947 & : ( not ( member$ rule52 $?gen947 ) ) ) ) ( test ( eq ( class ?gen945 ) crime_art152_2 ) ) => ( calc ( bind $?gen950 ( create$ rule52-overruled $?gen948 $?gen949 ) ) ) ?gen945 <- ( crime_art152_2 ( negative-overruled $?gen950 ) )"))

([rule52-support] of derived-attribute-rule
   (pos-name rule52-support-gen1686)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule52] ) ) ) ?gen943 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ?gen944 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ?gen945 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen947 & : ( not ( subseq-pos ( create$ rule52 ?gen943 ?gen944 $$$ $?gen947 ) ) ) ) ) ( test ( eq ( class ?gen945 ) crime_art152_2 ) ) => ( calc ( bind $?gen950 ( create$ rule52 ?gen943 ?gen944 $?gen947 ) ) ) ?gen945 <- ( crime_art152_2 ( positive-support $?gen950 ) )"))

([rule51-defeasibly-dot] of derived-attribute-rule
   (pos-name rule51-defeasibly-dot-gen1688)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule51] ) ) ) ?gen933 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule51 $? ) ) ( test ( eq ( class ?gen933 ) crime_art152_2 ) ) ( not ( and ?gen940 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen939 & : ( >= ?gen939 1 ) ) ) ?gen942 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen941 & : ( >= ?gen941 1 ) ) ) ?gen933 <- ( crime_art152_2 ( negative ~ 2 ) ( positive-overruled $?gen935 & : ( not ( member$ rule51 $?gen935 ) ) ) ) ) ) => ?gen933 <- ( crime_art152_2 ( positive 0 ) )"))

([rule51-defeasibly] of derived-attribute-rule
   (pos-name rule51-defeasibly-gen1690)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule51] ) ) ) ?gen940 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen939 & : ( >= ?gen939 1 ) ) ) ?gen942 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen941 & : ( >= ?gen941 1 ) ) ) ?gen933 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen935 & : ( not ( member$ rule51 $?gen935 ) ) ) ) ( test ( eq ( class ?gen933 ) crime_art152_2 ) ) => ?gen933 <- ( crime_art152_2 ( positive 1 ) ( positive-derivator rule51 ?gen940 ?gen942 ) )"))

([rule51-overruled-dot] of derived-attribute-rule
   (pos-name rule51-overruled-dot-gen1692)
   (depends-on declare crime_art152_2 lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule51] ) ) ) ?gen933 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen936 ) ( negative-overruled $?gen937 & : ( subseq-pos ( create$ rule51-overruled $?gen936 $$$ $?gen937 ) ) ) ) ( test ( eq ( class ?gen933 ) crime_art152_2 ) ) ( not ( and ?gen940 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen939 & : ( >= ?gen939 1 ) ) ) ?gen942 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen941 & : ( >= ?gen941 1 ) ) ) ?gen933 <- ( crime_art152_2 ( positive-defeated $?gen935 & : ( not ( member$ rule51 $?gen935 ) ) ) ) ) ) => ( calc ( bind $?gen938 ( delete-member$ $?gen937 ( create$ rule51-overruled $?gen936 ) ) ) ) ?gen933 <- ( crime_art152_2 ( negative-overruled $?gen938 ) )"))

([rule51-overruled] of derived-attribute-rule
   (pos-name rule51-overruled-gen1694)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule51] ) ) ) ?gen940 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen939 & : ( >= ?gen939 1 ) ) ) ?gen942 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ( positive ?gen941 & : ( >= ?gen941 1 ) ) ) ?gen933 <- ( crime_art152_2 ( defendant ?Defendant ) ( negative-support $?gen936 ) ( negative-overruled $?gen937 & : ( not ( subseq-pos ( create$ rule51-overruled $?gen936 $$$ $?gen937 ) ) ) ) ( positive-defeated $?gen935 & : ( not ( member$ rule51 $?gen935 ) ) ) ) ( test ( eq ( class ?gen933 ) crime_art152_2 ) ) => ( calc ( bind $?gen938 ( create$ rule51-overruled $?gen936 $?gen937 ) ) ) ?gen933 <- ( crime_art152_2 ( negative-overruled $?gen938 ) )"))

([rule51-support] of derived-attribute-rule
   (pos-name rule51-support-gen1696)
   (depends-on declare lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule51] ) ) ) ?gen931 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen932 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ?gen933 <- ( crime_art152_2 ( defendant ?Defendant ) ( positive-support $?gen935 & : ( not ( subseq-pos ( create$ rule51 ?gen931 ?gen932 $$$ $?gen935 ) ) ) ) ) ( test ( eq ( class ?gen933 ) crime_art152_2 ) ) => ( calc ( bind $?gen938 ( create$ rule51 ?gen931 ?gen932 $?gen935 ) ) ) ?gen933 <- ( crime_art152_2 ( positive-support $?gen938 ) )"))

([rule50-defeasibly-dot] of derived-attribute-rule
   (pos-name rule50-defeasibly-dot-gen1698)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule50] ) ) ) ?gen923 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule50 $? ) ) ( test ( eq ( class ?gen923 ) crime_art152_1 ) ) ( not ( and ?gen930 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen929 & : ( >= ?gen929 1 ) ) ) ?gen923 <- ( crime_art152_1 ( negative ~ 2 ) ( positive-overruled $?gen925 & : ( not ( member$ rule50 $?gen925 ) ) ) ) ) ) => ?gen923 <- ( crime_art152_1 ( positive 0 ) )"))

([rule50-defeasibly] of derived-attribute-rule
   (pos-name rule50-defeasibly-gen1700)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule50] ) ) ) ?gen930 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen929 & : ( >= ?gen929 1 ) ) ) ?gen923 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen925 & : ( not ( member$ rule50 $?gen925 ) ) ) ) ( test ( eq ( class ?gen923 ) crime_art152_1 ) ) => ?gen923 <- ( crime_art152_1 ( positive 1 ) ( positive-derivator rule50 ?gen930 ) )"))

([rule50-overruled-dot] of derived-attribute-rule
   (pos-name rule50-overruled-dot-gen1702)
   (depends-on declare crime_art152_1 lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule50] ) ) ) ?gen923 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen926 ) ( negative-overruled $?gen927 & : ( subseq-pos ( create$ rule50-overruled $?gen926 $$$ $?gen927 ) ) ) ) ( test ( eq ( class ?gen923 ) crime_art152_1 ) ) ( not ( and ?gen930 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen929 & : ( >= ?gen929 1 ) ) ) ?gen923 <- ( crime_art152_1 ( positive-defeated $?gen925 & : ( not ( member$ rule50 $?gen925 ) ) ) ) ) ) => ( calc ( bind $?gen928 ( delete-member$ $?gen927 ( create$ rule50-overruled $?gen926 ) ) ) ) ?gen923 <- ( crime_art152_1 ( negative-overruled $?gen928 ) )"))

([rule50-overruled] of derived-attribute-rule
   (pos-name rule50-overruled-gen1704)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule50] ) ) ) ?gen930 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ( positive ?gen929 & : ( >= ?gen929 1 ) ) ) ?gen923 <- ( crime_art152_1 ( defendant ?Defendant ) ( negative-support $?gen926 ) ( negative-overruled $?gen927 & : ( not ( subseq-pos ( create$ rule50-overruled $?gen926 $$$ $?gen927 ) ) ) ) ( positive-defeated $?gen925 & : ( not ( member$ rule50 $?gen925 ) ) ) ) ( test ( eq ( class ?gen923 ) crime_art152_1 ) ) => ( calc ( bind $?gen928 ( create$ rule50-overruled $?gen926 $?gen927 ) ) ) ?gen923 <- ( crime_art152_1 ( negative-overruled $?gen928 ) )"))

([rule50-support] of derived-attribute-rule
   (pos-name rule50-support-gen1706)
   (depends-on declare lc:case crime_art152_1)
   (implies crime_art152_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule50] ) ) ) ?gen922 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen923 <- ( crime_art152_1 ( defendant ?Defendant ) ( positive-support $?gen925 & : ( not ( subseq-pos ( create$ rule50 ?gen922 $$$ $?gen925 ) ) ) ) ) ( test ( eq ( class ?gen923 ) crime_art152_1 ) ) => ( calc ( bind $?gen928 ( create$ rule50 ?gen922 $?gen925 ) ) ) ?gen923 <- ( crime_art152_1 ( positive-support $?gen928 ) )"))

([rule49-defeasibly-dot] of derived-attribute-rule
   (pos-name rule49-defeasibly-dot-gen1708)
   (depends-on declare crime_art151b lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule49] ) ) ) ?gen910 <- ( crime_art151b ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule49 $? ) ) ( test ( eq ( class ?gen910 ) crime_art151b ) ) ( not ( and ?gen917 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen916 & : ( >= ?gen916 1 ) ) ) ?gen919 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen918 & : ( >= ?gen918 1 ) ) ) ?gen921 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen920 & : ( >= ?gen920 1 ) ) ) ?gen910 <- ( crime_art151b ( negative ~ 2 ) ( positive-overruled $?gen912 & : ( not ( member$ rule49 $?gen912 ) ) ) ) ) ) => ?gen910 <- ( crime_art151b ( positive 0 ) )"))

([rule49-defeasibly] of derived-attribute-rule
   (pos-name rule49-defeasibly-gen1710)
   (depends-on declare lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule49] ) ) ) ?gen917 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen916 & : ( >= ?gen916 1 ) ) ) ?gen919 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen918 & : ( >= ?gen918 1 ) ) ) ?gen921 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen920 & : ( >= ?gen920 1 ) ) ) ?gen910 <- ( crime_art151b ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen912 & : ( not ( member$ rule49 $?gen912 ) ) ) ) ( test ( eq ( class ?gen910 ) crime_art151b ) ) => ?gen910 <- ( crime_art151b ( positive 1 ) ( positive-derivator rule49 ?gen917 ?gen919 ?gen921 ) )"))

([rule49-overruled-dot] of derived-attribute-rule
   (pos-name rule49-overruled-dot-gen1712)
   (depends-on declare crime_art151b lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule49] ) ) ) ?gen910 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen913 ) ( negative-overruled $?gen914 & : ( subseq-pos ( create$ rule49-overruled $?gen913 $$$ $?gen914 ) ) ) ) ( test ( eq ( class ?gen910 ) crime_art151b ) ) ( not ( and ?gen917 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen916 & : ( >= ?gen916 1 ) ) ) ?gen919 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen918 & : ( >= ?gen918 1 ) ) ) ?gen921 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen920 & : ( >= ?gen920 1 ) ) ) ?gen910 <- ( crime_art151b ( positive-defeated $?gen912 & : ( not ( member$ rule49 $?gen912 ) ) ) ) ) ) => ( calc ( bind $?gen915 ( delete-member$ $?gen914 ( create$ rule49-overruled $?gen913 ) ) ) ) ?gen910 <- ( crime_art151b ( negative-overruled $?gen915 ) )"))

([rule49-overruled] of derived-attribute-rule
   (pos-name rule49-overruled-gen1714)
   (depends-on declare lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule49] ) ) ) ?gen917 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen916 & : ( >= ?gen916 1 ) ) ) ?gen919 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ( positive ?gen918 & : ( >= ?gen918 1 ) ) ) ?gen921 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen920 & : ( >= ?gen920 1 ) ) ) ?gen910 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen913 ) ( negative-overruled $?gen914 & : ( not ( subseq-pos ( create$ rule49-overruled $?gen913 $$$ $?gen914 ) ) ) ) ( positive-defeated $?gen912 & : ( not ( member$ rule49 $?gen912 ) ) ) ) ( test ( eq ( class ?gen910 ) crime_art151b ) ) => ( calc ( bind $?gen915 ( create$ rule49-overruled $?gen913 $?gen914 ) ) ) ?gen910 <- ( crime_art151b ( negative-overruled $?gen915 ) )"))

([rule49-support] of derived-attribute-rule
   (pos-name rule49-support-gen1716)
   (depends-on declare lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule49] ) ) ) ?gen907 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ?gen908 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ?gen909 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ?gen910 <- ( crime_art151b ( defendant ?Defendant ) ( positive-support $?gen912 & : ( not ( subseq-pos ( create$ rule49 ?gen907 ?gen908 ?gen909 $$$ $?gen912 ) ) ) ) ) ( test ( eq ( class ?gen910 ) crime_art151b ) ) => ( calc ( bind $?gen915 ( create$ rule49 ?gen907 ?gen908 ?gen909 $?gen912 ) ) ) ?gen910 <- ( crime_art151b ( positive-support $?gen915 ) )"))

([rule48-defeasibly-dot] of derived-attribute-rule
   (pos-name rule48-defeasibly-dot-gen1718)
   (depends-on declare crime_art151b lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule48] ) ) ) ?gen897 <- ( crime_art151b ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule48 $? ) ) ( test ( eq ( class ?gen897 ) crime_art151b ) ) ( not ( and ?gen904 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen903 & : ( >= ?gen903 1 ) ) ) ?gen906 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen905 & : ( >= ?gen905 1 ) ) ) ?gen897 <- ( crime_art151b ( negative ~ 2 ) ( positive-overruled $?gen899 & : ( not ( member$ rule48 $?gen899 ) ) ) ) ) ) => ?gen897 <- ( crime_art151b ( positive 0 ) )"))

([rule48-defeasibly] of derived-attribute-rule
   (pos-name rule48-defeasibly-gen1720)
   (depends-on declare lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule48] ) ) ) ?gen904 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen903 & : ( >= ?gen903 1 ) ) ) ?gen906 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen905 & : ( >= ?gen905 1 ) ) ) ?gen897 <- ( crime_art151b ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen899 & : ( not ( member$ rule48 $?gen899 ) ) ) ) ( test ( eq ( class ?gen897 ) crime_art151b ) ) => ?gen897 <- ( crime_art151b ( positive 1 ) ( positive-derivator rule48 ?gen904 ?gen906 ) )"))

([rule48-overruled-dot] of derived-attribute-rule
   (pos-name rule48-overruled-dot-gen1722)
   (depends-on declare crime_art151b lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule48] ) ) ) ?gen897 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen900 ) ( negative-overruled $?gen901 & : ( subseq-pos ( create$ rule48-overruled $?gen900 $$$ $?gen901 ) ) ) ) ( test ( eq ( class ?gen897 ) crime_art151b ) ) ( not ( and ?gen904 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen903 & : ( >= ?gen903 1 ) ) ) ?gen906 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen905 & : ( >= ?gen905 1 ) ) ) ?gen897 <- ( crime_art151b ( positive-defeated $?gen899 & : ( not ( member$ rule48 $?gen899 ) ) ) ) ) ) => ( calc ( bind $?gen902 ( delete-member$ $?gen901 ( create$ rule48-overruled $?gen900 ) ) ) ) ?gen897 <- ( crime_art151b ( negative-overruled $?gen902 ) )"))

([rule48-overruled] of derived-attribute-rule
   (pos-name rule48-overruled-gen1724)
   (depends-on declare lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule48] ) ) ) ?gen904 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ( positive ?gen903 & : ( >= ?gen903 1 ) ) ) ?gen906 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen905 & : ( >= ?gen905 1 ) ) ) ?gen897 <- ( crime_art151b ( defendant ?Defendant ) ( negative-support $?gen900 ) ( negative-overruled $?gen901 & : ( not ( subseq-pos ( create$ rule48-overruled $?gen900 $$$ $?gen901 ) ) ) ) ( positive-defeated $?gen899 & : ( not ( member$ rule48 $?gen899 ) ) ) ) ( test ( eq ( class ?gen897 ) crime_art151b ) ) => ( calc ( bind $?gen902 ( create$ rule48-overruled $?gen900 $?gen901 ) ) ) ?gen897 <- ( crime_art151b ( negative-overruled $?gen902 ) )"))

([rule48-support] of derived-attribute-rule
   (pos-name rule48-support-gen1726)
   (depends-on declare lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule48] ) ) ) ?gen895 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ?gen896 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ?gen897 <- ( crime_art151b ( defendant ?Defendant ) ( positive-support $?gen899 & : ( not ( subseq-pos ( create$ rule48 ?gen895 ?gen896 $$$ $?gen899 ) ) ) ) ) ( test ( eq ( class ?gen897 ) crime_art151b ) ) => ( calc ( bind $?gen902 ( create$ rule48 ?gen895 ?gen896 $?gen899 ) ) ) ?gen897 <- ( crime_art151b ( positive-support $?gen902 ) )"))

([rule47-defeasibly-dot] of derived-attribute-rule
   (pos-name rule47-defeasibly-dot-gen1728)
   (depends-on declare crime_art151a lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule47] ) ) ) ?gen887 <- ( crime_art151a ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule47 $? ) ) ( test ( eq ( class ?gen887 ) crime_art151a ) ) ( not ( and ?gen894 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen893 & : ( >= ?gen893 1 ) ) ) ?gen887 <- ( crime_art151a ( negative ~ 2 ) ( positive-overruled $?gen889 & : ( not ( member$ rule47 $?gen889 ) ) ) ) ) ) => ?gen887 <- ( crime_art151a ( positive 0 ) )"))

([rule47-defeasibly] of derived-attribute-rule
   (pos-name rule47-defeasibly-gen1730)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule47] ) ) ) ?gen894 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen893 & : ( >= ?gen893 1 ) ) ) ?gen887 <- ( crime_art151a ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen889 & : ( not ( member$ rule47 $?gen889 ) ) ) ) ( test ( eq ( class ?gen887 ) crime_art151a ) ) => ?gen887 <- ( crime_art151a ( positive 1 ) ( positive-derivator rule47 ?gen894 ) )"))

([rule47-overruled-dot] of derived-attribute-rule
   (pos-name rule47-overruled-dot-gen1732)
   (depends-on declare crime_art151a lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule47] ) ) ) ?gen887 <- ( crime_art151a ( defendant ?Defendant ) ( negative-support $?gen890 ) ( negative-overruled $?gen891 & : ( subseq-pos ( create$ rule47-overruled $?gen890 $$$ $?gen891 ) ) ) ) ( test ( eq ( class ?gen887 ) crime_art151a ) ) ( not ( and ?gen894 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen893 & : ( >= ?gen893 1 ) ) ) ?gen887 <- ( crime_art151a ( positive-defeated $?gen889 & : ( not ( member$ rule47 $?gen889 ) ) ) ) ) ) => ( calc ( bind $?gen892 ( delete-member$ $?gen891 ( create$ rule47-overruled $?gen890 ) ) ) ) ?gen887 <- ( crime_art151a ( negative-overruled $?gen892 ) )"))

([rule47-overruled] of derived-attribute-rule
   (pos-name rule47-overruled-gen1734)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule47] ) ) ) ?gen894 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ( positive ?gen893 & : ( >= ?gen893 1 ) ) ) ?gen887 <- ( crime_art151a ( defendant ?Defendant ) ( negative-support $?gen890 ) ( negative-overruled $?gen891 & : ( not ( subseq-pos ( create$ rule47-overruled $?gen890 $$$ $?gen891 ) ) ) ) ( positive-defeated $?gen889 & : ( not ( member$ rule47 $?gen889 ) ) ) ) ( test ( eq ( class ?gen887 ) crime_art151a ) ) => ( calc ( bind $?gen892 ( create$ rule47-overruled $?gen890 $?gen891 ) ) ) ?gen887 <- ( crime_art151a ( negative-overruled $?gen892 ) )"))

([rule47-support] of derived-attribute-rule
   (pos-name rule47-support-gen1736)
   (depends-on declare lc:case crime_art151a)
   (implies crime_art151a)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule47] ) ) ) ?gen886 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ?gen887 <- ( crime_art151a ( defendant ?Defendant ) ( positive-support $?gen889 & : ( not ( subseq-pos ( create$ rule47 ?gen886 $$$ $?gen889 ) ) ) ) ) ( test ( eq ( class ?gen887 ) crime_art151a ) ) => ( calc ( bind $?gen892 ( create$ rule47 ?gen886 $?gen889 ) ) ) ?gen887 <- ( crime_art151a ( positive-support $?gen892 ) )"))

([rule46b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule46b-defeasibly-dot-gen1738)
   (depends-on declare crime_art151_5 lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule46b] ) ) ) ?gen864 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule46b $? ) ) ( test ( eq ( class ?gen864 ) crime_art151_5 ) ) ( not ( and ?gen871 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen870 & : ( >= ?gen870 1 ) ) ) ?gen873 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen872 & : ( >= ?gen872 1 ) ) ) ?gen875 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen874 & : ( >= ?gen874 1 ) ) ) ?gen877 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen876 & : ( >= ?gen876 1 ) ) ) ?gen879 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen878 & : ( >= ?gen878 1 ) ) ) ?gen881 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( positive ?gen880 & : ( >= ?gen880 1 ) ) ) ?gen883 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen882 & : ( >= ?gen882 1 ) ) ) ?gen885 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen884 & : ( >= ?gen884 1 ) ) ) ?gen864 <- ( crime_art151_5 ( negative ~ 2 ) ( positive-overruled $?gen866 & : ( not ( member$ rule46b $?gen866 ) ) ) ) ) ) => ?gen864 <- ( crime_art151_5 ( positive 0 ) )"))

([rule46b-defeasibly] of derived-attribute-rule
   (pos-name rule46b-defeasibly-gen1740)
   (depends-on declare lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule46b] ) ) ) ?gen871 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen870 & : ( >= ?gen870 1 ) ) ) ?gen873 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen872 & : ( >= ?gen872 1 ) ) ) ?gen875 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen874 & : ( >= ?gen874 1 ) ) ) ?gen877 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen876 & : ( >= ?gen876 1 ) ) ) ?gen879 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen878 & : ( >= ?gen878 1 ) ) ) ?gen881 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( positive ?gen880 & : ( >= ?gen880 1 ) ) ) ?gen883 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen882 & : ( >= ?gen882 1 ) ) ) ?gen885 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen884 & : ( >= ?gen884 1 ) ) ) ?gen864 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen866 & : ( not ( member$ rule46b $?gen866 ) ) ) ) ( test ( eq ( class ?gen864 ) crime_art151_5 ) ) => ?gen864 <- ( crime_art151_5 ( positive 1 ) ( positive-derivator rule46b ?gen871 ?gen873 ?gen875 ?gen877 ?gen879 ?gen881 ?gen883 ?gen885 ) )"))

([rule46b-overruled-dot] of derived-attribute-rule
   (pos-name rule46b-overruled-dot-gen1742)
   (depends-on declare crime_art151_5 lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule46b] ) ) ) ?gen864 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen867 ) ( negative-overruled $?gen868 & : ( subseq-pos ( create$ rule46b-overruled $?gen867 $$$ $?gen868 ) ) ) ) ( test ( eq ( class ?gen864 ) crime_art151_5 ) ) ( not ( and ?gen871 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen870 & : ( >= ?gen870 1 ) ) ) ?gen873 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen872 & : ( >= ?gen872 1 ) ) ) ?gen875 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen874 & : ( >= ?gen874 1 ) ) ) ?gen877 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen876 & : ( >= ?gen876 1 ) ) ) ?gen879 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen878 & : ( >= ?gen878 1 ) ) ) ?gen881 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( positive ?gen880 & : ( >= ?gen880 1 ) ) ) ?gen883 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen882 & : ( >= ?gen882 1 ) ) ) ?gen885 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen884 & : ( >= ?gen884 1 ) ) ) ?gen864 <- ( crime_art151_5 ( positive-defeated $?gen866 & : ( not ( member$ rule46b $?gen866 ) ) ) ) ) ) => ( calc ( bind $?gen869 ( delete-member$ $?gen868 ( create$ rule46b-overruled $?gen867 ) ) ) ) ?gen864 <- ( crime_art151_5 ( negative-overruled $?gen869 ) )"))

([rule46b-overruled] of derived-attribute-rule
   (pos-name rule46b-overruled-gen1744)
   (depends-on declare lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule46b] ) ) ) ?gen871 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen870 & : ( >= ?gen870 1 ) ) ) ?gen873 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen872 & : ( >= ?gen872 1 ) ) ) ?gen875 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen874 & : ( >= ?gen874 1 ) ) ) ?gen877 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen876 & : ( >= ?gen876 1 ) ) ) ?gen879 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen878 & : ( >= ?gen878 1 ) ) ) ?gen881 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( positive ?gen880 & : ( >= ?gen880 1 ) ) ) ?gen883 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen882 & : ( >= ?gen882 1 ) ) ) ?gen885 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen884 & : ( >= ?gen884 1 ) ) ) ?gen864 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen867 ) ( negative-overruled $?gen868 & : ( not ( subseq-pos ( create$ rule46b-overruled $?gen867 $$$ $?gen868 ) ) ) ) ( positive-defeated $?gen866 & : ( not ( member$ rule46b $?gen866 ) ) ) ) ( test ( eq ( class ?gen864 ) crime_art151_5 ) ) => ( calc ( bind $?gen869 ( create$ rule46b-overruled $?gen867 $?gen868 ) ) ) ?gen864 <- ( crime_art151_5 ( negative-overruled $?gen869 ) )"))

([rule46b-support] of derived-attribute-rule
   (pos-name rule46b-support-gen1746)
   (depends-on declare lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule46b] ) ) ) ?gen856 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen857 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen858 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ?gen859 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen860 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen861 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ) ?gen862 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen863 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ?gen864 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive-support $?gen866 & : ( not ( subseq-pos ( create$ rule46b ?gen856 ?gen857 ?gen858 ?gen859 ?gen860 ?gen861 ?gen862 ?gen863 $$$ $?gen866 ) ) ) ) ) ( test ( eq ( class ?gen864 ) crime_art151_5 ) ) => ( calc ( bind $?gen869 ( create$ rule46b ?gen856 ?gen857 ?gen858 ?gen859 ?gen860 ?gen861 ?gen862 ?gen863 $?gen866 ) ) ) ?gen864 <- ( crime_art151_5 ( positive-support $?gen869 ) )"))

([rule46-defeasibly-dot] of derived-attribute-rule
   (pos-name rule46-defeasibly-dot-gen1748)
   (depends-on declare crime_art151_5 lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule46] ) ) ) ?gen824 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule46 $? ) ) ( test ( eq ( class ?gen824 ) crime_art151_5 ) ) ( not ( and ?gen831 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen830 & : ( >= ?gen830 1 ) ) ) ?gen833 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen832 & : ( >= ?gen832 1 ) ) ) ?gen835 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen834 & : ( >= ?gen834 1 ) ) ) ?gen837 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen836 & : ( >= ?gen836 1 ) ) ) ?gen839 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen838 & : ( >= ?gen838 1 ) ) ) ?gen841 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( negative ?gen840 & : ( >= ?gen840 1 ) ) ) ?gen843 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( negative ?gen842 & : ( >= ?gen842 1 ) ) ) ?gen845 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( negative ?gen844 & : ( >= ?gen844 1 ) ) ) ?gen847 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( negative ?gen846 & : ( >= ?gen846 1 ) ) ) ?gen849 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( negative ?gen848 & : ( >= ?gen848 1 ) ) ) ?gen851 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( negative ?gen850 & : ( >= ?gen850 1 ) ) ) ?gen853 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen852 & : ( >= ?gen852 1 ) ) ) ?gen855 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen854 & : ( >= ?gen854 1 ) ) ) ?gen824 <- ( crime_art151_5 ( negative ~ 2 ) ( positive-overruled $?gen826 & : ( not ( member$ rule46 $?gen826 ) ) ) ) ) ) => ?gen824 <- ( crime_art151_5 ( positive 0 ) )"))

([rule46-defeasibly] of derived-attribute-rule
   (pos-name rule46-defeasibly-gen1750)
   (depends-on declare lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule46] ) ) ) ?gen831 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen830 & : ( >= ?gen830 1 ) ) ) ?gen833 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen832 & : ( >= ?gen832 1 ) ) ) ?gen835 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen834 & : ( >= ?gen834 1 ) ) ) ?gen837 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen836 & : ( >= ?gen836 1 ) ) ) ?gen839 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen838 & : ( >= ?gen838 1 ) ) ) ?gen841 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( negative ?gen840 & : ( >= ?gen840 1 ) ) ) ?gen843 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( negative ?gen842 & : ( >= ?gen842 1 ) ) ) ?gen845 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( negative ?gen844 & : ( >= ?gen844 1 ) ) ) ?gen847 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( negative ?gen846 & : ( >= ?gen846 1 ) ) ) ?gen849 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( negative ?gen848 & : ( >= ?gen848 1 ) ) ) ?gen851 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( negative ?gen850 & : ( >= ?gen850 1 ) ) ) ?gen853 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen852 & : ( >= ?gen852 1 ) ) ) ?gen855 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen854 & : ( >= ?gen854 1 ) ) ) ?gen824 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen826 & : ( not ( member$ rule46 $?gen826 ) ) ) ) ( test ( eq ( class ?gen824 ) crime_art151_5 ) ) => ?gen824 <- ( crime_art151_5 ( positive 1 ) ( positive-derivator rule46 ?gen831 ?gen833 ?gen835 ?gen837 ?gen839 ?gen841 ?gen843 ?gen845 ?gen847 ?gen849 ?gen851 ?gen853 ?gen855 ) )"))

([rule46-overruled-dot] of derived-attribute-rule
   (pos-name rule46-overruled-dot-gen1752)
   (depends-on declare crime_art151_5 lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule46] ) ) ) ?gen824 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen827 ) ( negative-overruled $?gen828 & : ( subseq-pos ( create$ rule46-overruled $?gen827 $$$ $?gen828 ) ) ) ) ( test ( eq ( class ?gen824 ) crime_art151_5 ) ) ( not ( and ?gen831 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen830 & : ( >= ?gen830 1 ) ) ) ?gen833 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen832 & : ( >= ?gen832 1 ) ) ) ?gen835 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen834 & : ( >= ?gen834 1 ) ) ) ?gen837 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen836 & : ( >= ?gen836 1 ) ) ) ?gen839 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen838 & : ( >= ?gen838 1 ) ) ) ?gen841 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( negative ?gen840 & : ( >= ?gen840 1 ) ) ) ?gen843 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( negative ?gen842 & : ( >= ?gen842 1 ) ) ) ?gen845 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( negative ?gen844 & : ( >= ?gen844 1 ) ) ) ?gen847 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( negative ?gen846 & : ( >= ?gen846 1 ) ) ) ?gen849 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( negative ?gen848 & : ( >= ?gen848 1 ) ) ) ?gen851 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( negative ?gen850 & : ( >= ?gen850 1 ) ) ) ?gen853 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen852 & : ( >= ?gen852 1 ) ) ) ?gen855 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen854 & : ( >= ?gen854 1 ) ) ) ?gen824 <- ( crime_art151_5 ( positive-defeated $?gen826 & : ( not ( member$ rule46 $?gen826 ) ) ) ) ) ) => ( calc ( bind $?gen829 ( delete-member$ $?gen828 ( create$ rule46-overruled $?gen827 ) ) ) ) ?gen824 <- ( crime_art151_5 ( negative-overruled $?gen829 ) )"))

([rule46-overruled] of derived-attribute-rule
   (pos-name rule46-overruled-gen1754)
   (depends-on declare lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule46] ) ) ) ?gen831 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen830 & : ( >= ?gen830 1 ) ) ) ?gen833 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen832 & : ( >= ?gen832 1 ) ) ) ?gen835 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( positive ?gen834 & : ( >= ?gen834 1 ) ) ) ?gen837 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen836 & : ( >= ?gen836 1 ) ) ) ?gen839 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen838 & : ( >= ?gen838 1 ) ) ) ?gen841 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( negative ?gen840 & : ( >= ?gen840 1 ) ) ) ?gen843 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( negative ?gen842 & : ( >= ?gen842 1 ) ) ) ?gen845 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( negative ?gen844 & : ( >= ?gen844 1 ) ) ) ?gen847 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( negative ?gen846 & : ( >= ?gen846 1 ) ) ) ?gen849 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( negative ?gen848 & : ( >= ?gen848 1 ) ) ) ?gen851 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( negative ?gen850 & : ( >= ?gen850 1 ) ) ) ?gen853 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( negative ?gen852 & : ( >= ?gen852 1 ) ) ) ?gen855 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( negative ?gen854 & : ( >= ?gen854 1 ) ) ) ?gen824 <- ( crime_art151_5 ( defendant ?Defendant ) ( negative-support $?gen827 ) ( negative-overruled $?gen828 & : ( not ( subseq-pos ( create$ rule46-overruled $?gen827 $$$ $?gen828 ) ) ) ) ( positive-defeated $?gen826 & : ( not ( member$ rule46 $?gen826 ) ) ) ) ( test ( eq ( class ?gen824 ) crime_art151_5 ) ) => ( calc ( bind $?gen829 ( create$ rule46-overruled $?gen827 $?gen828 ) ) ) ?gen824 <- ( crime_art151_5 ( negative-overruled $?gen829 ) )"))

([rule46-support] of derived-attribute-rule
   (pos-name rule46-support-gen1756)
   (depends-on declare lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule46] ) ) ) ?gen811 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen812 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen813 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ?gen814 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen815 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen816 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ?gen817 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ?gen818 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ?gen819 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ?gen820 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ?gen821 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ?gen822 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen823 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ?gen824 <- ( crime_art151_5 ( defendant ?Defendant ) ( positive-support $?gen826 & : ( not ( subseq-pos ( create$ rule46 ?gen811 ?gen812 ?gen813 ?gen814 ?gen815 ?gen816 ?gen817 ?gen818 ?gen819 ?gen820 ?gen821 ?gen822 ?gen823 $$$ $?gen826 ) ) ) ) ) ( test ( eq ( class ?gen824 ) crime_art151_5 ) ) => ( calc ( bind $?gen829 ( create$ rule46 ?gen811 ?gen812 ?gen813 ?gen814 ?gen815 ?gen816 ?gen817 ?gen818 ?gen819 ?gen820 ?gen821 ?gen822 ?gen823 $?gen826 ) ) ) ?gen824 <- ( crime_art151_5 ( positive-support $?gen829 ) )"))

([rule45-defeasibly-dot] of derived-attribute-rule
   (pos-name rule45-defeasibly-dot-gen1758)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule45] ) ) ) ?gen801 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule45 $? ) ) ( test ( eq ( class ?gen801 ) crime_art151_4 ) ) ( not ( and ?gen808 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen807 & : ( >= ?gen807 1 ) ) ) ?gen810 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen809 & : ( >= ?gen809 1 ) ) ) ?gen801 <- ( crime_art151_4 ( negative ~ 2 ) ( positive-overruled $?gen803 & : ( not ( member$ rule45 $?gen803 ) ) ) ) ) ) => ?gen801 <- ( crime_art151_4 ( positive 0 ) )"))

([rule45-defeasibly] of derived-attribute-rule
   (pos-name rule45-defeasibly-gen1760)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule45] ) ) ) ?gen808 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen807 & : ( >= ?gen807 1 ) ) ) ?gen810 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen809 & : ( >= ?gen809 1 ) ) ) ?gen801 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen803 & : ( not ( member$ rule45 $?gen803 ) ) ) ) ( test ( eq ( class ?gen801 ) crime_art151_4 ) ) => ?gen801 <- ( crime_art151_4 ( positive 1 ) ( positive-derivator rule45 ?gen808 ?gen810 ) )"))

([rule45-overruled-dot] of derived-attribute-rule
   (pos-name rule45-overruled-dot-gen1762)
   (depends-on declare crime_art151_4 lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule45] ) ) ) ?gen801 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen804 ) ( negative-overruled $?gen805 & : ( subseq-pos ( create$ rule45-overruled $?gen804 $$$ $?gen805 ) ) ) ) ( test ( eq ( class ?gen801 ) crime_art151_4 ) ) ( not ( and ?gen808 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen807 & : ( >= ?gen807 1 ) ) ) ?gen810 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen809 & : ( >= ?gen809 1 ) ) ) ?gen801 <- ( crime_art151_4 ( positive-defeated $?gen803 & : ( not ( member$ rule45 $?gen803 ) ) ) ) ) ) => ( calc ( bind $?gen806 ( delete-member$ $?gen805 ( create$ rule45-overruled $?gen804 ) ) ) ) ?gen801 <- ( crime_art151_4 ( negative-overruled $?gen806 ) )"))

([rule45-overruled] of derived-attribute-rule
   (pos-name rule45-overruled-gen1764)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule45] ) ) ) ?gen808 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen807 & : ( >= ?gen807 1 ) ) ) ?gen810 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ( positive ?gen809 & : ( >= ?gen809 1 ) ) ) ?gen801 <- ( crime_art151_4 ( defendant ?Defendant ) ( negative-support $?gen804 ) ( negative-overruled $?gen805 & : ( not ( subseq-pos ( create$ rule45-overruled $?gen804 $$$ $?gen805 ) ) ) ) ( positive-defeated $?gen803 & : ( not ( member$ rule45 $?gen803 ) ) ) ) ( test ( eq ( class ?gen801 ) crime_art151_4 ) ) => ( calc ( bind $?gen806 ( create$ rule45-overruled $?gen804 $?gen805 ) ) ) ?gen801 <- ( crime_art151_4 ( negative-overruled $?gen806 ) )"))

([rule45-support] of derived-attribute-rule
   (pos-name rule45-support-gen1766)
   (depends-on declare lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule45] ) ) ) ?gen799 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen800 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ?gen801 <- ( crime_art151_4 ( defendant ?Defendant ) ( positive-support $?gen803 & : ( not ( subseq-pos ( create$ rule45 ?gen799 ?gen800 $$$ $?gen803 ) ) ) ) ) ( test ( eq ( class ?gen801 ) crime_art151_4 ) ) => ( calc ( bind $?gen806 ( create$ rule45 ?gen799 ?gen800 $?gen803 ) ) ) ?gen801 <- ( crime_art151_4 ( positive-support $?gen806 ) )"))

([rule44-defeasibly-dot] of derived-attribute-rule
   (pos-name rule44-defeasibly-dot-gen1768)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule44] ) ) ) ?gen789 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule44 $? ) ) ( test ( eq ( class ?gen789 ) crime_art151_3 ) ) ( not ( and ?gen796 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen795 & : ( >= ?gen795 1 ) ) ) ?gen798 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen797 & : ( >= ?gen797 1 ) ) ) ?gen789 <- ( crime_art151_3 ( negative ~ 2 ) ( positive-overruled $?gen791 & : ( not ( member$ rule44 $?gen791 ) ) ) ) ) ) => ?gen789 <- ( crime_art151_3 ( positive 0 ) )"))

([rule44-defeasibly] of derived-attribute-rule
   (pos-name rule44-defeasibly-gen1770)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule44] ) ) ) ?gen796 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen795 & : ( >= ?gen795 1 ) ) ) ?gen798 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen797 & : ( >= ?gen797 1 ) ) ) ?gen789 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen791 & : ( not ( member$ rule44 $?gen791 ) ) ) ) ( test ( eq ( class ?gen789 ) crime_art151_3 ) ) => ?gen789 <- ( crime_art151_3 ( positive 1 ) ( positive-derivator rule44 ?gen796 ?gen798 ) )"))

([rule44-overruled-dot] of derived-attribute-rule
   (pos-name rule44-overruled-dot-gen1772)
   (depends-on declare crime_art151_3 lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule44] ) ) ) ?gen789 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen792 ) ( negative-overruled $?gen793 & : ( subseq-pos ( create$ rule44-overruled $?gen792 $$$ $?gen793 ) ) ) ) ( test ( eq ( class ?gen789 ) crime_art151_3 ) ) ( not ( and ?gen796 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen795 & : ( >= ?gen795 1 ) ) ) ?gen798 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen797 & : ( >= ?gen797 1 ) ) ) ?gen789 <- ( crime_art151_3 ( positive-defeated $?gen791 & : ( not ( member$ rule44 $?gen791 ) ) ) ) ) ) => ( calc ( bind $?gen794 ( delete-member$ $?gen793 ( create$ rule44-overruled $?gen792 ) ) ) ) ?gen789 <- ( crime_art151_3 ( negative-overruled $?gen794 ) )"))

([rule44-overruled] of derived-attribute-rule
   (pos-name rule44-overruled-gen1774)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule44] ) ) ) ?gen796 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen795 & : ( >= ?gen795 1 ) ) ) ?gen798 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ( positive ?gen797 & : ( >= ?gen797 1 ) ) ) ?gen789 <- ( crime_art151_3 ( defendant ?Defendant ) ( negative-support $?gen792 ) ( negative-overruled $?gen793 & : ( not ( subseq-pos ( create$ rule44-overruled $?gen792 $$$ $?gen793 ) ) ) ) ( positive-defeated $?gen791 & : ( not ( member$ rule44 $?gen791 ) ) ) ) ( test ( eq ( class ?gen789 ) crime_art151_3 ) ) => ( calc ( bind $?gen794 ( create$ rule44-overruled $?gen792 $?gen793 ) ) ) ?gen789 <- ( crime_art151_3 ( negative-overruled $?gen794 ) )"))

([rule44-support] of derived-attribute-rule
   (pos-name rule44-support-gen1776)
   (depends-on declare lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule44] ) ) ) ?gen787 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen788 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen789 <- ( crime_art151_3 ( defendant ?Defendant ) ( positive-support $?gen791 & : ( not ( subseq-pos ( create$ rule44 ?gen787 ?gen788 $$$ $?gen791 ) ) ) ) ) ( test ( eq ( class ?gen789 ) crime_art151_3 ) ) => ( calc ( bind $?gen794 ( create$ rule44 ?gen787 ?gen788 $?gen791 ) ) ) ?gen789 <- ( crime_art151_3 ( positive-support $?gen794 ) )"))

([rule43f-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43f-defeasibly-dot-gen1778)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43f] ) ) ) ?gen777 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43f $? ) ) ( test ( eq ( class ?gen777 ) crime_art151_2 ) ) ( not ( and ?gen784 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen783 & : ( >= ?gen783 1 ) ) ) ?gen786 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( positive ?gen785 & : ( >= ?gen785 1 ) ) ) ?gen777 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen779 & : ( not ( member$ rule43f $?gen779 ) ) ) ) ) ) => ?gen777 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43f-defeasibly] of derived-attribute-rule
   (pos-name rule43f-defeasibly-gen1780)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43f] ) ) ) ?gen784 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen783 & : ( >= ?gen783 1 ) ) ) ?gen786 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( positive ?gen785 & : ( >= ?gen785 1 ) ) ) ?gen777 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen779 & : ( not ( member$ rule43f $?gen779 ) ) ) ) ( test ( eq ( class ?gen777 ) crime_art151_2 ) ) => ?gen777 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43f ?gen784 ?gen786 ) )"))

([rule43f-overruled-dot] of derived-attribute-rule
   (pos-name rule43f-overruled-dot-gen1782)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43f] ) ) ) ?gen777 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen780 ) ( negative-overruled $?gen781 & : ( subseq-pos ( create$ rule43f-overruled $?gen780 $$$ $?gen781 ) ) ) ) ( test ( eq ( class ?gen777 ) crime_art151_2 ) ) ( not ( and ?gen784 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen783 & : ( >= ?gen783 1 ) ) ) ?gen786 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( positive ?gen785 & : ( >= ?gen785 1 ) ) ) ?gen777 <- ( crime_art151_2 ( positive-defeated $?gen779 & : ( not ( member$ rule43f $?gen779 ) ) ) ) ) ) => ( calc ( bind $?gen782 ( delete-member$ $?gen781 ( create$ rule43f-overruled $?gen780 ) ) ) ) ?gen777 <- ( crime_art151_2 ( negative-overruled $?gen782 ) )"))

([rule43f-overruled] of derived-attribute-rule
   (pos-name rule43f-overruled-gen1784)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43f] ) ) ) ?gen784 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen783 & : ( >= ?gen783 1 ) ) ) ?gen786 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ( positive ?gen785 & : ( >= ?gen785 1 ) ) ) ?gen777 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen780 ) ( negative-overruled $?gen781 & : ( not ( subseq-pos ( create$ rule43f-overruled $?gen780 $$$ $?gen781 ) ) ) ) ( positive-defeated $?gen779 & : ( not ( member$ rule43f $?gen779 ) ) ) ) ( test ( eq ( class ?gen777 ) crime_art151_2 ) ) => ( calc ( bind $?gen782 ( create$ rule43f-overruled $?gen780 $?gen781 ) ) ) ?gen777 <- ( crime_art151_2 ( negative-overruled $?gen782 ) )"))

([rule43f-support] of derived-attribute-rule
   (pos-name rule43f-support-gen1786)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43f] ) ) ) ?gen775 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen776 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ?gen777 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen779 & : ( not ( subseq-pos ( create$ rule43f ?gen775 ?gen776 $$$ $?gen779 ) ) ) ) ) ( test ( eq ( class ?gen777 ) crime_art151_2 ) ) => ( calc ( bind $?gen782 ( create$ rule43f ?gen775 ?gen776 $?gen779 ) ) ) ?gen777 <- ( crime_art151_2 ( positive-support $?gen782 ) )"))

([rule43e-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43e-defeasibly-dot-gen1788)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43e] ) ) ) ?gen765 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43e $? ) ) ( test ( eq ( class ?gen765 ) crime_art151_2 ) ) ( not ( and ?gen772 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen771 & : ( >= ?gen771 1 ) ) ) ?gen774 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( positive ?gen773 & : ( >= ?gen773 1 ) ) ) ?gen765 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen767 & : ( not ( member$ rule43e $?gen767 ) ) ) ) ) ) => ?gen765 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43e-defeasibly] of derived-attribute-rule
   (pos-name rule43e-defeasibly-gen1790)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43e] ) ) ) ?gen772 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen771 & : ( >= ?gen771 1 ) ) ) ?gen774 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( positive ?gen773 & : ( >= ?gen773 1 ) ) ) ?gen765 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen767 & : ( not ( member$ rule43e $?gen767 ) ) ) ) ( test ( eq ( class ?gen765 ) crime_art151_2 ) ) => ?gen765 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43e ?gen772 ?gen774 ) )"))

([rule43e-overruled-dot] of derived-attribute-rule
   (pos-name rule43e-overruled-dot-gen1792)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43e] ) ) ) ?gen765 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen768 ) ( negative-overruled $?gen769 & : ( subseq-pos ( create$ rule43e-overruled $?gen768 $$$ $?gen769 ) ) ) ) ( test ( eq ( class ?gen765 ) crime_art151_2 ) ) ( not ( and ?gen772 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen771 & : ( >= ?gen771 1 ) ) ) ?gen774 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( positive ?gen773 & : ( >= ?gen773 1 ) ) ) ?gen765 <- ( crime_art151_2 ( positive-defeated $?gen767 & : ( not ( member$ rule43e $?gen767 ) ) ) ) ) ) => ( calc ( bind $?gen770 ( delete-member$ $?gen769 ( create$ rule43e-overruled $?gen768 ) ) ) ) ?gen765 <- ( crime_art151_2 ( negative-overruled $?gen770 ) )"))

([rule43e-overruled] of derived-attribute-rule
   (pos-name rule43e-overruled-gen1794)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43e] ) ) ) ?gen772 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen771 & : ( >= ?gen771 1 ) ) ) ?gen774 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ( positive ?gen773 & : ( >= ?gen773 1 ) ) ) ?gen765 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen768 ) ( negative-overruled $?gen769 & : ( not ( subseq-pos ( create$ rule43e-overruled $?gen768 $$$ $?gen769 ) ) ) ) ( positive-defeated $?gen767 & : ( not ( member$ rule43e $?gen767 ) ) ) ) ( test ( eq ( class ?gen765 ) crime_art151_2 ) ) => ( calc ( bind $?gen770 ( create$ rule43e-overruled $?gen768 $?gen769 ) ) ) ?gen765 <- ( crime_art151_2 ( negative-overruled $?gen770 ) )"))

([rule43e-support] of derived-attribute-rule
   (pos-name rule43e-support-gen1796)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43e] ) ) ) ?gen763 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen764 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ?gen765 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen767 & : ( not ( subseq-pos ( create$ rule43e ?gen763 ?gen764 $$$ $?gen767 ) ) ) ) ) ( test ( eq ( class ?gen765 ) crime_art151_2 ) ) => ( calc ( bind $?gen770 ( create$ rule43e ?gen763 ?gen764 $?gen767 ) ) ) ?gen765 <- ( crime_art151_2 ( positive-support $?gen770 ) )"))

([rule43d-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43d-defeasibly-dot-gen1798)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43d] ) ) ) ?gen753 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43d $? ) ) ( test ( eq ( class ?gen753 ) crime_art151_2 ) ) ( not ( and ?gen760 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen759 & : ( >= ?gen759 1 ) ) ) ?gen762 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( positive ?gen761 & : ( >= ?gen761 1 ) ) ) ?gen753 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen755 & : ( not ( member$ rule43d $?gen755 ) ) ) ) ) ) => ?gen753 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43d-defeasibly] of derived-attribute-rule
   (pos-name rule43d-defeasibly-gen1800)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43d] ) ) ) ?gen760 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen759 & : ( >= ?gen759 1 ) ) ) ?gen762 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( positive ?gen761 & : ( >= ?gen761 1 ) ) ) ?gen753 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen755 & : ( not ( member$ rule43d $?gen755 ) ) ) ) ( test ( eq ( class ?gen753 ) crime_art151_2 ) ) => ?gen753 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43d ?gen760 ?gen762 ) )"))

([rule43d-overruled-dot] of derived-attribute-rule
   (pos-name rule43d-overruled-dot-gen1802)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43d] ) ) ) ?gen753 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen756 ) ( negative-overruled $?gen757 & : ( subseq-pos ( create$ rule43d-overruled $?gen756 $$$ $?gen757 ) ) ) ) ( test ( eq ( class ?gen753 ) crime_art151_2 ) ) ( not ( and ?gen760 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen759 & : ( >= ?gen759 1 ) ) ) ?gen762 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( positive ?gen761 & : ( >= ?gen761 1 ) ) ) ?gen753 <- ( crime_art151_2 ( positive-defeated $?gen755 & : ( not ( member$ rule43d $?gen755 ) ) ) ) ) ) => ( calc ( bind $?gen758 ( delete-member$ $?gen757 ( create$ rule43d-overruled $?gen756 ) ) ) ) ?gen753 <- ( crime_art151_2 ( negative-overruled $?gen758 ) )"))

([rule43d-overruled] of derived-attribute-rule
   (pos-name rule43d-overruled-gen1804)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43d] ) ) ) ?gen760 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen759 & : ( >= ?gen759 1 ) ) ) ?gen762 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ( positive ?gen761 & : ( >= ?gen761 1 ) ) ) ?gen753 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen756 ) ( negative-overruled $?gen757 & : ( not ( subseq-pos ( create$ rule43d-overruled $?gen756 $$$ $?gen757 ) ) ) ) ( positive-defeated $?gen755 & : ( not ( member$ rule43d $?gen755 ) ) ) ) ( test ( eq ( class ?gen753 ) crime_art151_2 ) ) => ( calc ( bind $?gen758 ( create$ rule43d-overruled $?gen756 $?gen757 ) ) ) ?gen753 <- ( crime_art151_2 ( negative-overruled $?gen758 ) )"))

([rule43d-support] of derived-attribute-rule
   (pos-name rule43d-support-gen1806)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43d] ) ) ) ?gen751 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen752 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ?gen753 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen755 & : ( not ( subseq-pos ( create$ rule43d ?gen751 ?gen752 $$$ $?gen755 ) ) ) ) ) ( test ( eq ( class ?gen753 ) crime_art151_2 ) ) => ( calc ( bind $?gen758 ( create$ rule43d ?gen751 ?gen752 $?gen755 ) ) ) ?gen753 <- ( crime_art151_2 ( positive-support $?gen758 ) )"))

([rule43c-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43c-defeasibly-dot-gen1808)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43c] ) ) ) ?gen741 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43c $? ) ) ( test ( eq ( class ?gen741 ) crime_art151_2 ) ) ( not ( and ?gen748 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen747 & : ( >= ?gen747 1 ) ) ) ?gen750 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( positive ?gen749 & : ( >= ?gen749 1 ) ) ) ?gen741 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen743 & : ( not ( member$ rule43c $?gen743 ) ) ) ) ) ) => ?gen741 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43c-defeasibly] of derived-attribute-rule
   (pos-name rule43c-defeasibly-gen1810)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43c] ) ) ) ?gen748 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen747 & : ( >= ?gen747 1 ) ) ) ?gen750 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( positive ?gen749 & : ( >= ?gen749 1 ) ) ) ?gen741 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen743 & : ( not ( member$ rule43c $?gen743 ) ) ) ) ( test ( eq ( class ?gen741 ) crime_art151_2 ) ) => ?gen741 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43c ?gen748 ?gen750 ) )"))

([rule43c-overruled-dot] of derived-attribute-rule
   (pos-name rule43c-overruled-dot-gen1812)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43c] ) ) ) ?gen741 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen744 ) ( negative-overruled $?gen745 & : ( subseq-pos ( create$ rule43c-overruled $?gen744 $$$ $?gen745 ) ) ) ) ( test ( eq ( class ?gen741 ) crime_art151_2 ) ) ( not ( and ?gen748 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen747 & : ( >= ?gen747 1 ) ) ) ?gen750 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( positive ?gen749 & : ( >= ?gen749 1 ) ) ) ?gen741 <- ( crime_art151_2 ( positive-defeated $?gen743 & : ( not ( member$ rule43c $?gen743 ) ) ) ) ) ) => ( calc ( bind $?gen746 ( delete-member$ $?gen745 ( create$ rule43c-overruled $?gen744 ) ) ) ) ?gen741 <- ( crime_art151_2 ( negative-overruled $?gen746 ) )"))

([rule43c-overruled] of derived-attribute-rule
   (pos-name rule43c-overruled-gen1814)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43c] ) ) ) ?gen748 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen747 & : ( >= ?gen747 1 ) ) ) ?gen750 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ( positive ?gen749 & : ( >= ?gen749 1 ) ) ) ?gen741 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen744 ) ( negative-overruled $?gen745 & : ( not ( subseq-pos ( create$ rule43c-overruled $?gen744 $$$ $?gen745 ) ) ) ) ( positive-defeated $?gen743 & : ( not ( member$ rule43c $?gen743 ) ) ) ) ( test ( eq ( class ?gen741 ) crime_art151_2 ) ) => ( calc ( bind $?gen746 ( create$ rule43c-overruled $?gen744 $?gen745 ) ) ) ?gen741 <- ( crime_art151_2 ( negative-overruled $?gen746 ) )"))

([rule43c-support] of derived-attribute-rule
   (pos-name rule43c-support-gen1816)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43c] ) ) ) ?gen739 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen740 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ?gen741 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen743 & : ( not ( subseq-pos ( create$ rule43c ?gen739 ?gen740 $$$ $?gen743 ) ) ) ) ) ( test ( eq ( class ?gen741 ) crime_art151_2 ) ) => ( calc ( bind $?gen746 ( create$ rule43c ?gen739 ?gen740 $?gen743 ) ) ) ?gen741 <- ( crime_art151_2 ( positive-support $?gen746 ) )"))

([rule43b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43b-defeasibly-dot-gen1818)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43b] ) ) ) ?gen729 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43b $? ) ) ( test ( eq ( class ?gen729 ) crime_art151_2 ) ) ( not ( and ?gen736 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen735 & : ( >= ?gen735 1 ) ) ) ?gen738 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( positive ?gen737 & : ( >= ?gen737 1 ) ) ) ?gen729 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen731 & : ( not ( member$ rule43b $?gen731 ) ) ) ) ) ) => ?gen729 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43b-defeasibly] of derived-attribute-rule
   (pos-name rule43b-defeasibly-gen1820)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43b] ) ) ) ?gen736 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen735 & : ( >= ?gen735 1 ) ) ) ?gen738 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( positive ?gen737 & : ( >= ?gen737 1 ) ) ) ?gen729 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen731 & : ( not ( member$ rule43b $?gen731 ) ) ) ) ( test ( eq ( class ?gen729 ) crime_art151_2 ) ) => ?gen729 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43b ?gen736 ?gen738 ) )"))

([rule43b-overruled-dot] of derived-attribute-rule
   (pos-name rule43b-overruled-dot-gen1822)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43b] ) ) ) ?gen729 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen732 ) ( negative-overruled $?gen733 & : ( subseq-pos ( create$ rule43b-overruled $?gen732 $$$ $?gen733 ) ) ) ) ( test ( eq ( class ?gen729 ) crime_art151_2 ) ) ( not ( and ?gen736 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen735 & : ( >= ?gen735 1 ) ) ) ?gen738 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( positive ?gen737 & : ( >= ?gen737 1 ) ) ) ?gen729 <- ( crime_art151_2 ( positive-defeated $?gen731 & : ( not ( member$ rule43b $?gen731 ) ) ) ) ) ) => ( calc ( bind $?gen734 ( delete-member$ $?gen733 ( create$ rule43b-overruled $?gen732 ) ) ) ) ?gen729 <- ( crime_art151_2 ( negative-overruled $?gen734 ) )"))

([rule43b-overruled] of derived-attribute-rule
   (pos-name rule43b-overruled-gen1824)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43b] ) ) ) ?gen736 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen735 & : ( >= ?gen735 1 ) ) ) ?gen738 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ( positive ?gen737 & : ( >= ?gen737 1 ) ) ) ?gen729 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen732 ) ( negative-overruled $?gen733 & : ( not ( subseq-pos ( create$ rule43b-overruled $?gen732 $$$ $?gen733 ) ) ) ) ( positive-defeated $?gen731 & : ( not ( member$ rule43b $?gen731 ) ) ) ) ( test ( eq ( class ?gen729 ) crime_art151_2 ) ) => ( calc ( bind $?gen734 ( create$ rule43b-overruled $?gen732 $?gen733 ) ) ) ?gen729 <- ( crime_art151_2 ( negative-overruled $?gen734 ) )"))

([rule43b-support] of derived-attribute-rule
   (pos-name rule43b-support-gen1826)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43b] ) ) ) ?gen727 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen728 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ?gen729 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen731 & : ( not ( subseq-pos ( create$ rule43b ?gen727 ?gen728 $$$ $?gen731 ) ) ) ) ) ( test ( eq ( class ?gen729 ) crime_art151_2 ) ) => ( calc ( bind $?gen734 ( create$ rule43b ?gen727 ?gen728 $?gen731 ) ) ) ?gen729 <- ( crime_art151_2 ( positive-support $?gen734 ) )"))

([rule43-defeasibly-dot] of derived-attribute-rule
   (pos-name rule43-defeasibly-dot-gen1828)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule43] ) ) ) ?gen717 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule43 $? ) ) ( test ( eq ( class ?gen717 ) crime_art151_2 ) ) ( not ( and ?gen724 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen723 & : ( >= ?gen723 1 ) ) ) ?gen726 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( positive ?gen725 & : ( >= ?gen725 1 ) ) ) ?gen717 <- ( crime_art151_2 ( negative ~ 2 ) ( positive-overruled $?gen719 & : ( not ( member$ rule43 $?gen719 ) ) ) ) ) ) => ?gen717 <- ( crime_art151_2 ( positive 0 ) )"))

([rule43-defeasibly] of derived-attribute-rule
   (pos-name rule43-defeasibly-gen1830)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule43] ) ) ) ?gen724 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen723 & : ( >= ?gen723 1 ) ) ) ?gen726 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( positive ?gen725 & : ( >= ?gen725 1 ) ) ) ?gen717 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen719 & : ( not ( member$ rule43 $?gen719 ) ) ) ) ( test ( eq ( class ?gen717 ) crime_art151_2 ) ) => ?gen717 <- ( crime_art151_2 ( positive 1 ) ( positive-derivator rule43 ?gen724 ?gen726 ) )"))

([rule43-overruled-dot] of derived-attribute-rule
   (pos-name rule43-overruled-dot-gen1832)
   (depends-on declare crime_art151_2 lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule43] ) ) ) ?gen717 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen720 ) ( negative-overruled $?gen721 & : ( subseq-pos ( create$ rule43-overruled $?gen720 $$$ $?gen721 ) ) ) ) ( test ( eq ( class ?gen717 ) crime_art151_2 ) ) ( not ( and ?gen724 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen723 & : ( >= ?gen723 1 ) ) ) ?gen726 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( positive ?gen725 & : ( >= ?gen725 1 ) ) ) ?gen717 <- ( crime_art151_2 ( positive-defeated $?gen719 & : ( not ( member$ rule43 $?gen719 ) ) ) ) ) ) => ( calc ( bind $?gen722 ( delete-member$ $?gen721 ( create$ rule43-overruled $?gen720 ) ) ) ) ?gen717 <- ( crime_art151_2 ( negative-overruled $?gen722 ) )"))

([rule43-overruled] of derived-attribute-rule
   (pos-name rule43-overruled-gen1834)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule43] ) ) ) ?gen724 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen723 & : ( >= ?gen723 1 ) ) ) ?gen726 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ( positive ?gen725 & : ( >= ?gen725 1 ) ) ) ?gen717 <- ( crime_art151_2 ( defendant ?Defendant ) ( negative-support $?gen720 ) ( negative-overruled $?gen721 & : ( not ( subseq-pos ( create$ rule43-overruled $?gen720 $$$ $?gen721 ) ) ) ) ( positive-defeated $?gen719 & : ( not ( member$ rule43 $?gen719 ) ) ) ) ( test ( eq ( class ?gen717 ) crime_art151_2 ) ) => ( calc ( bind $?gen722 ( create$ rule43-overruled $?gen720 $?gen721 ) ) ) ?gen717 <- ( crime_art151_2 ( negative-overruled $?gen722 ) )"))

([rule43-support] of derived-attribute-rule
   (pos-name rule43-support-gen1836)
   (depends-on declare lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule43] ) ) ) ?gen715 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen716 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ?gen717 <- ( crime_art151_2 ( defendant ?Defendant ) ( positive-support $?gen719 & : ( not ( subseq-pos ( create$ rule43 ?gen715 ?gen716 $$$ $?gen719 ) ) ) ) ) ( test ( eq ( class ?gen717 ) crime_art151_2 ) ) => ( calc ( bind $?gen722 ( create$ rule43 ?gen715 ?gen716 $?gen719 ) ) ) ?gen717 <- ( crime_art151_2 ( positive-support $?gen722 ) )"))

([rule41-defeasibly-dot] of derived-attribute-rule
   (pos-name rule41-defeasibly-dot-gen1838)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule41] ) ) ) ?gen707 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule41 $? ) ) ( test ( eq ( class ?gen707 ) crime_art151_1 ) ) ( not ( and ?gen714 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen713 & : ( >= ?gen713 1 ) ) ) ?gen707 <- ( crime_art151_1 ( negative ~ 2 ) ( positive-overruled $?gen709 & : ( not ( member$ rule41 $?gen709 ) ) ) ) ) ) => ?gen707 <- ( crime_art151_1 ( positive 0 ) )"))

([rule41-defeasibly] of derived-attribute-rule
   (pos-name rule41-defeasibly-gen1840)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule41] ) ) ) ?gen714 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen713 & : ( >= ?gen713 1 ) ) ) ?gen707 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen709 & : ( not ( member$ rule41 $?gen709 ) ) ) ) ( test ( eq ( class ?gen707 ) crime_art151_1 ) ) => ?gen707 <- ( crime_art151_1 ( positive 1 ) ( positive-derivator rule41 ?gen714 ) )"))

([rule41-overruled-dot] of derived-attribute-rule
   (pos-name rule41-overruled-dot-gen1842)
   (depends-on declare crime_art151_1 lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule41] ) ) ) ?gen707 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen710 ) ( negative-overruled $?gen711 & : ( subseq-pos ( create$ rule41-overruled $?gen710 $$$ $?gen711 ) ) ) ) ( test ( eq ( class ?gen707 ) crime_art151_1 ) ) ( not ( and ?gen714 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen713 & : ( >= ?gen713 1 ) ) ) ?gen707 <- ( crime_art151_1 ( positive-defeated $?gen709 & : ( not ( member$ rule41 $?gen709 ) ) ) ) ) ) => ( calc ( bind $?gen712 ( delete-member$ $?gen711 ( create$ rule41-overruled $?gen710 ) ) ) ) ?gen707 <- ( crime_art151_1 ( negative-overruled $?gen712 ) )"))

([rule41-overruled] of derived-attribute-rule
   (pos-name rule41-overruled-gen1844)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule41] ) ) ) ?gen714 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ( positive ?gen713 & : ( >= ?gen713 1 ) ) ) ?gen707 <- ( crime_art151_1 ( defendant ?Defendant ) ( negative-support $?gen710 ) ( negative-overruled $?gen711 & : ( not ( subseq-pos ( create$ rule41-overruled $?gen710 $$$ $?gen711 ) ) ) ) ( positive-defeated $?gen709 & : ( not ( member$ rule41 $?gen709 ) ) ) ) ( test ( eq ( class ?gen707 ) crime_art151_1 ) ) => ( calc ( bind $?gen712 ( create$ rule41-overruled $?gen710 $?gen711 ) ) ) ?gen707 <- ( crime_art151_1 ( negative-overruled $?gen712 ) )"))

([rule41-support] of derived-attribute-rule
   (pos-name rule41-support-gen1846)
   (depends-on declare lc:case crime_art151_1)
   (implies crime_art151_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule41] ) ) ) ?gen706 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen707 <- ( crime_art151_1 ( defendant ?Defendant ) ( positive-support $?gen709 & : ( not ( subseq-pos ( create$ rule41 ?gen706 $$$ $?gen709 ) ) ) ) ) ( test ( eq ( class ?gen707 ) crime_art151_1 ) ) => ( calc ( bind $?gen712 ( create$ rule41 ?gen706 $?gen709 ) ) ) ?gen707 <- ( crime_art151_1 ( positive-support $?gen712 ) )"))

([rule40b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule40b-defeasibly-dot-gen1848)
   (depends-on declare crime_art150_3 lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule40b] ) ) ) ?gen692 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule40b $? ) ) ( test ( eq ( class ?gen692 ) crime_art150_3 ) ) ( not ( and ?gen699 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen698 & : ( >= ?gen698 1 ) ) ) ?gen701 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen700 & : ( >= ?gen700 1 ) ) ) ?gen703 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ( positive ?gen702 & : ( >= ?gen702 1 ) ) ) ?gen705 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen704 & : ( >= ?gen704 1 ) ) ) ?gen692 <- ( crime_art150_3 ( negative ~ 2 ) ( positive-overruled $?gen694 & : ( not ( member$ rule40b $?gen694 ) ) ) ) ) ) => ?gen692 <- ( crime_art150_3 ( positive 0 ) )"))

([rule40b-defeasibly] of derived-attribute-rule
   (pos-name rule40b-defeasibly-gen1850)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule40b] ) ) ) ?gen699 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen698 & : ( >= ?gen698 1 ) ) ) ?gen701 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen700 & : ( >= ?gen700 1 ) ) ) ?gen703 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ( positive ?gen702 & : ( >= ?gen702 1 ) ) ) ?gen705 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen704 & : ( >= ?gen704 1 ) ) ) ?gen692 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen694 & : ( not ( member$ rule40b $?gen694 ) ) ) ) ( test ( eq ( class ?gen692 ) crime_art150_3 ) ) => ?gen692 <- ( crime_art150_3 ( positive 1 ) ( positive-derivator rule40b ?gen699 ?gen701 ?gen703 ?gen705 ) )"))

([rule40b-overruled-dot] of derived-attribute-rule
   (pos-name rule40b-overruled-dot-gen1852)
   (depends-on declare crime_art150_3 lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule40b] ) ) ) ?gen692 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen695 ) ( negative-overruled $?gen696 & : ( subseq-pos ( create$ rule40b-overruled $?gen695 $$$ $?gen696 ) ) ) ) ( test ( eq ( class ?gen692 ) crime_art150_3 ) ) ( not ( and ?gen699 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen698 & : ( >= ?gen698 1 ) ) ) ?gen701 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen700 & : ( >= ?gen700 1 ) ) ) ?gen703 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ( positive ?gen702 & : ( >= ?gen702 1 ) ) ) ?gen705 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen704 & : ( >= ?gen704 1 ) ) ) ?gen692 <- ( crime_art150_3 ( positive-defeated $?gen694 & : ( not ( member$ rule40b $?gen694 ) ) ) ) ) ) => ( calc ( bind $?gen697 ( delete-member$ $?gen696 ( create$ rule40b-overruled $?gen695 ) ) ) ) ?gen692 <- ( crime_art150_3 ( negative-overruled $?gen697 ) )"))

([rule40b-overruled] of derived-attribute-rule
   (pos-name rule40b-overruled-gen1854)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule40b] ) ) ) ?gen699 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen698 & : ( >= ?gen698 1 ) ) ) ?gen701 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen700 & : ( >= ?gen700 1 ) ) ) ?gen703 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ( positive ?gen702 & : ( >= ?gen702 1 ) ) ) ?gen705 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen704 & : ( >= ?gen704 1 ) ) ) ?gen692 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen695 ) ( negative-overruled $?gen696 & : ( not ( subseq-pos ( create$ rule40b-overruled $?gen695 $$$ $?gen696 ) ) ) ) ( positive-defeated $?gen694 & : ( not ( member$ rule40b $?gen694 ) ) ) ) ( test ( eq ( class ?gen692 ) crime_art150_3 ) ) => ( calc ( bind $?gen697 ( create$ rule40b-overruled $?gen695 $?gen696 ) ) ) ?gen692 <- ( crime_art150_3 ( negative-overruled $?gen697 ) )"))

([rule40b-support] of derived-attribute-rule
   (pos-name rule40b-support-gen1856)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule40b] ) ) ) ?gen688 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen689 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ?gen690 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ) ?gen691 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ?gen692 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive-support $?gen694 & : ( not ( subseq-pos ( create$ rule40b ?gen688 ?gen689 ?gen690 ?gen691 $$$ $?gen694 ) ) ) ) ) ( test ( eq ( class ?gen692 ) crime_art150_3 ) ) => ( calc ( bind $?gen697 ( create$ rule40b ?gen688 ?gen689 ?gen690 ?gen691 $?gen694 ) ) ) ?gen692 <- ( crime_art150_3 ( positive-support $?gen697 ) )"))

([rule39b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule39b-defeasibly-dot-gen1858)
   (depends-on declare crime_art150_3 lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule39b] ) ) ) ?gen674 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule39b $? ) ) ( test ( eq ( class ?gen674 ) crime_art150_3 ) ) ( not ( and ?gen681 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen680 & : ( >= ?gen680 1 ) ) ) ?gen683 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen682 & : ( >= ?gen682 1 ) ) ) ?gen685 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ( positive ?gen684 & : ( >= ?gen684 1 ) ) ) ?gen687 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen686 & : ( >= ?gen686 1 ) ) ) ?gen674 <- ( crime_art150_3 ( negative ~ 2 ) ( positive-overruled $?gen676 & : ( not ( member$ rule39b $?gen676 ) ) ) ) ) ) => ?gen674 <- ( crime_art150_3 ( positive 0 ) )"))

([rule39b-defeasibly] of derived-attribute-rule
   (pos-name rule39b-defeasibly-gen1860)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule39b] ) ) ) ?gen681 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen680 & : ( >= ?gen680 1 ) ) ) ?gen683 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen682 & : ( >= ?gen682 1 ) ) ) ?gen685 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ( positive ?gen684 & : ( >= ?gen684 1 ) ) ) ?gen687 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen686 & : ( >= ?gen686 1 ) ) ) ?gen674 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen676 & : ( not ( member$ rule39b $?gen676 ) ) ) ) ( test ( eq ( class ?gen674 ) crime_art150_3 ) ) => ?gen674 <- ( crime_art150_3 ( positive 1 ) ( positive-derivator rule39b ?gen681 ?gen683 ?gen685 ?gen687 ) )"))

([rule39b-overruled-dot] of derived-attribute-rule
   (pos-name rule39b-overruled-dot-gen1862)
   (depends-on declare crime_art150_3 lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule39b] ) ) ) ?gen674 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen677 ) ( negative-overruled $?gen678 & : ( subseq-pos ( create$ rule39b-overruled $?gen677 $$$ $?gen678 ) ) ) ) ( test ( eq ( class ?gen674 ) crime_art150_3 ) ) ( not ( and ?gen681 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen680 & : ( >= ?gen680 1 ) ) ) ?gen683 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen682 & : ( >= ?gen682 1 ) ) ) ?gen685 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ( positive ?gen684 & : ( >= ?gen684 1 ) ) ) ?gen687 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen686 & : ( >= ?gen686 1 ) ) ) ?gen674 <- ( crime_art150_3 ( positive-defeated $?gen676 & : ( not ( member$ rule39b $?gen676 ) ) ) ) ) ) => ( calc ( bind $?gen679 ( delete-member$ $?gen678 ( create$ rule39b-overruled $?gen677 ) ) ) ) ?gen674 <- ( crime_art150_3 ( negative-overruled $?gen679 ) )"))

([rule39b-overruled] of derived-attribute-rule
   (pos-name rule39b-overruled-gen1864)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule39b] ) ) ) ?gen681 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen680 & : ( >= ?gen680 1 ) ) ) ?gen683 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( positive ?gen682 & : ( >= ?gen682 1 ) ) ) ?gen685 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ( positive ?gen684 & : ( >= ?gen684 1 ) ) ) ?gen687 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen686 & : ( >= ?gen686 1 ) ) ) ?gen674 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen677 ) ( negative-overruled $?gen678 & : ( not ( subseq-pos ( create$ rule39b-overruled $?gen677 $$$ $?gen678 ) ) ) ) ( positive-defeated $?gen676 & : ( not ( member$ rule39b $?gen676 ) ) ) ) ( test ( eq ( class ?gen674 ) crime_art150_3 ) ) => ( calc ( bind $?gen679 ( create$ rule39b-overruled $?gen677 $?gen678 ) ) ) ?gen674 <- ( crime_art150_3 ( negative-overruled $?gen679 ) )"))

([rule39b-support] of derived-attribute-rule
   (pos-name rule39b-support-gen1866)
   (depends-on declare lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule39b] ) ) ) ?gen670 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen671 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ?gen672 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ) ?gen673 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ?gen674 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive-support $?gen676 & : ( not ( subseq-pos ( create$ rule39b ?gen670 ?gen671 ?gen672 ?gen673 $$$ $?gen676 ) ) ) ) ) ( test ( eq ( class ?gen674 ) crime_art150_3 ) ) => ( calc ( bind $?gen679 ( create$ rule39b ?gen670 ?gen671 ?gen672 ?gen673 $?gen676 ) ) ) ?gen674 <- ( crime_art150_3 ( positive-support $?gen679 ) )"))

([rule38b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule38b-defeasibly-dot-gen1868)
   (depends-on declare crime_art150_3 lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule38b] ) ) ) ?gen654 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule38b $? ) ) ( test ( eq ( class ?gen654 ) crime_art150_3 ) ) ( not ( and ?gen661 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen660 & : ( >= ?gen660 1 ) ) ) ?gen663 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen662 & : ( >= ?gen662 1 ) ) ) ?gen665 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( positive ?gen664 & : ( >= ?gen664 1 ) ) ) ?gen667 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ( positive ?gen666 & : ( >= ?gen666 1 ) ) ) ?gen669 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen668 & : ( >= ?gen668 1 ) ) ) ?gen654 <- ( crime_art150_3 ( negative ~ 2 ) ( positive-overruled $?gen656 & : ( not ( member$ rule38b $?gen656 ) ) ) ) ) ) => ?gen654 <- ( crime_art150_3 ( positive 0 ) )"))

([rule38b-defeasibly] of derived-attribute-rule
   (pos-name rule38b-defeasibly-gen1870)
   (depends-on declare lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule38b] ) ) ) ?gen661 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen660 & : ( >= ?gen660 1 ) ) ) ?gen663 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen662 & : ( >= ?gen662 1 ) ) ) ?gen665 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( positive ?gen664 & : ( >= ?gen664 1 ) ) ) ?gen667 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ( positive ?gen666 & : ( >= ?gen666 1 ) ) ) ?gen669 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen668 & : ( >= ?gen668 1 ) ) ) ?gen654 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen656 & : ( not ( member$ rule38b $?gen656 ) ) ) ) ( test ( eq ( class ?gen654 ) crime_art150_3 ) ) => ?gen654 <- ( crime_art150_3 ( positive 1 ) ( positive-derivator rule38b ?gen661 ?gen663 ?gen665 ?gen667 ?gen669 ) )"))

([rule38b-overruled-dot] of derived-attribute-rule
   (pos-name rule38b-overruled-dot-gen1872)
   (depends-on declare crime_art150_3 lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule38b] ) ) ) ?gen654 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen657 ) ( negative-overruled $?gen658 & : ( subseq-pos ( create$ rule38b-overruled $?gen657 $$$ $?gen658 ) ) ) ) ( test ( eq ( class ?gen654 ) crime_art150_3 ) ) ( not ( and ?gen661 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen660 & : ( >= ?gen660 1 ) ) ) ?gen663 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen662 & : ( >= ?gen662 1 ) ) ) ?gen665 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( positive ?gen664 & : ( >= ?gen664 1 ) ) ) ?gen667 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ( positive ?gen666 & : ( >= ?gen666 1 ) ) ) ?gen669 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen668 & : ( >= ?gen668 1 ) ) ) ?gen654 <- ( crime_art150_3 ( positive-defeated $?gen656 & : ( not ( member$ rule38b $?gen656 ) ) ) ) ) ) => ( calc ( bind $?gen659 ( delete-member$ $?gen658 ( create$ rule38b-overruled $?gen657 ) ) ) ) ?gen654 <- ( crime_art150_3 ( negative-overruled $?gen659 ) )"))

([rule38b-overruled] of derived-attribute-rule
   (pos-name rule38b-overruled-gen1874)
   (depends-on declare lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule38b] ) ) ) ?gen661 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen660 & : ( >= ?gen660 1 ) ) ) ?gen663 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen662 & : ( >= ?gen662 1 ) ) ) ?gen665 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( positive ?gen664 & : ( >= ?gen664 1 ) ) ) ?gen667 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ( positive ?gen666 & : ( >= ?gen666 1 ) ) ) ?gen669 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( negative ?gen668 & : ( >= ?gen668 1 ) ) ) ?gen654 <- ( crime_art150_3 ( defendant ?Defendant ) ( negative-support $?gen657 ) ( negative-overruled $?gen658 & : ( not ( subseq-pos ( create$ rule38b-overruled $?gen657 $$$ $?gen658 ) ) ) ) ( positive-defeated $?gen656 & : ( not ( member$ rule38b $?gen656 ) ) ) ) ( test ( eq ( class ?gen654 ) crime_art150_3 ) ) => ( calc ( bind $?gen659 ( create$ rule38b-overruled $?gen657 $?gen658 ) ) ) ?gen654 <- ( crime_art150_3 ( negative-overruled $?gen659 ) )"))

([rule38b-support] of derived-attribute-rule
   (pos-name rule38b-support-gen1876)
   (depends-on declare lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule38b] ) ) ) ?gen649 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen650 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen651 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ) ?gen652 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ) ?gen653 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ?gen654 <- ( crime_art150_3 ( defendant ?Defendant ) ( positive-support $?gen656 & : ( not ( subseq-pos ( create$ rule38b ?gen649 ?gen650 ?gen651 ?gen652 ?gen653 $$$ $?gen656 ) ) ) ) ) ( test ( eq ( class ?gen654 ) crime_art150_3 ) ) => ( calc ( bind $?gen659 ( create$ rule38b ?gen649 ?gen650 ?gen651 ?gen652 ?gen653 $?gen656 ) ) ) ?gen654 <- ( crime_art150_3 ( positive-support $?gen659 ) )"))

([rule37-defeasibly-dot] of derived-attribute-rule
   (pos-name rule37-defeasibly-dot-gen1878)
   (depends-on declare crime_art150_2 lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule37] ) ) ) ?gen637 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule37 $? ) ) ( test ( eq ( class ?gen637 ) crime_art150_2 ) ) ( not ( and ?gen644 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen643 & : ( >= ?gen643 1 ) ) ) ?gen646 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ( positive ?gen645 & : ( >= ?gen645 1 ) ) ) ?gen648 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ( positive ?gen647 & : ( >= ?gen647 1 ) ) ) ?gen637 <- ( crime_art150_2 ( negative ~ 2 ) ( positive-overruled $?gen639 & : ( not ( member$ rule37 $?gen639 ) ) ) ) ) ) => ?gen637 <- ( crime_art150_2 ( positive 0 ) )"))

([rule37-defeasibly] of derived-attribute-rule
   (pos-name rule37-defeasibly-gen1880)
   (depends-on declare lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule37] ) ) ) ?gen644 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen643 & : ( >= ?gen643 1 ) ) ) ?gen646 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ( positive ?gen645 & : ( >= ?gen645 1 ) ) ) ?gen648 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ( positive ?gen647 & : ( >= ?gen647 1 ) ) ) ?gen637 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen639 & : ( not ( member$ rule37 $?gen639 ) ) ) ) ( test ( eq ( class ?gen637 ) crime_art150_2 ) ) => ?gen637 <- ( crime_art150_2 ( positive 1 ) ( positive-derivator rule37 ?gen644 ?gen646 ?gen648 ) )"))

([rule37-overruled-dot] of derived-attribute-rule
   (pos-name rule37-overruled-dot-gen1882)
   (depends-on declare crime_art150_2 lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule37] ) ) ) ?gen637 <- ( crime_art150_2 ( defendant ?Defendant ) ( negative-support $?gen640 ) ( negative-overruled $?gen641 & : ( subseq-pos ( create$ rule37-overruled $?gen640 $$$ $?gen641 ) ) ) ) ( test ( eq ( class ?gen637 ) crime_art150_2 ) ) ( not ( and ?gen644 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen643 & : ( >= ?gen643 1 ) ) ) ?gen646 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ( positive ?gen645 & : ( >= ?gen645 1 ) ) ) ?gen648 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ( positive ?gen647 & : ( >= ?gen647 1 ) ) ) ?gen637 <- ( crime_art150_2 ( positive-defeated $?gen639 & : ( not ( member$ rule37 $?gen639 ) ) ) ) ) ) => ( calc ( bind $?gen642 ( delete-member$ $?gen641 ( create$ rule37-overruled $?gen640 ) ) ) ) ?gen637 <- ( crime_art150_2 ( negative-overruled $?gen642 ) )"))

([rule37-overruled] of derived-attribute-rule
   (pos-name rule37-overruled-gen1884)
   (depends-on declare lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule37] ) ) ) ?gen644 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen643 & : ( >= ?gen643 1 ) ) ) ?gen646 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ( positive ?gen645 & : ( >= ?gen645 1 ) ) ) ?gen648 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ( positive ?gen647 & : ( >= ?gen647 1 ) ) ) ?gen637 <- ( crime_art150_2 ( defendant ?Defendant ) ( negative-support $?gen640 ) ( negative-overruled $?gen641 & : ( not ( subseq-pos ( create$ rule37-overruled $?gen640 $$$ $?gen641 ) ) ) ) ( positive-defeated $?gen639 & : ( not ( member$ rule37 $?gen639 ) ) ) ) ( test ( eq ( class ?gen637 ) crime_art150_2 ) ) => ( calc ( bind $?gen642 ( create$ rule37-overruled $?gen640 $?gen641 ) ) ) ?gen637 <- ( crime_art150_2 ( negative-overruled $?gen642 ) )"))

([rule37-support] of derived-attribute-rule
   (pos-name rule37-support-gen1886)
   (depends-on declare lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule37] ) ) ) ?gen634 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen635 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ?gen636 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ?gen637 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive-support $?gen639 & : ( not ( subseq-pos ( create$ rule37 ?gen634 ?gen635 ?gen636 $$$ $?gen639 ) ) ) ) ) ( test ( eq ( class ?gen637 ) crime_art150_2 ) ) => ( calc ( bind $?gen642 ( create$ rule37 ?gen634 ?gen635 ?gen636 $?gen639 ) ) ) ?gen637 <- ( crime_art150_2 ( positive-support $?gen642 ) )"))

([rule36b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule36b-defeasibly-dot-gen1888)
   (depends-on declare crime_art150_2 lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule36b] ) ) ) ?gen624 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule36b $? ) ) ( test ( eq ( class ?gen624 ) crime_art150_2 ) ) ( not ( and ?gen631 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen630 & : ( >= ?gen630 1 ) ) ) ?gen633 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen632 & : ( >= ?gen632 1 ) ) ) ?gen624 <- ( crime_art150_2 ( negative ~ 2 ) ( positive-overruled $?gen626 & : ( not ( member$ rule36b $?gen626 ) ) ) ) ) ) => ?gen624 <- ( crime_art150_2 ( positive 0 ) )"))

([rule36b-defeasibly] of derived-attribute-rule
   (pos-name rule36b-defeasibly-gen1890)
   (depends-on declare lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule36b] ) ) ) ?gen631 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen630 & : ( >= ?gen630 1 ) ) ) ?gen633 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen632 & : ( >= ?gen632 1 ) ) ) ?gen624 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen626 & : ( not ( member$ rule36b $?gen626 ) ) ) ) ( test ( eq ( class ?gen624 ) crime_art150_2 ) ) => ?gen624 <- ( crime_art150_2 ( positive 1 ) ( positive-derivator rule36b ?gen631 ?gen633 ) )"))

([rule36b-overruled-dot] of derived-attribute-rule
   (pos-name rule36b-overruled-dot-gen1892)
   (depends-on declare crime_art150_2 lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule36b] ) ) ) ?gen624 <- ( crime_art150_2 ( defendant ?Defendant ) ( negative-support $?gen627 ) ( negative-overruled $?gen628 & : ( subseq-pos ( create$ rule36b-overruled $?gen627 $$$ $?gen628 ) ) ) ) ( test ( eq ( class ?gen624 ) crime_art150_2 ) ) ( not ( and ?gen631 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen630 & : ( >= ?gen630 1 ) ) ) ?gen633 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen632 & : ( >= ?gen632 1 ) ) ) ?gen624 <- ( crime_art150_2 ( positive-defeated $?gen626 & : ( not ( member$ rule36b $?gen626 ) ) ) ) ) ) => ( calc ( bind $?gen629 ( delete-member$ $?gen628 ( create$ rule36b-overruled $?gen627 ) ) ) ) ?gen624 <- ( crime_art150_2 ( negative-overruled $?gen629 ) )"))

([rule36b-overruled] of derived-attribute-rule
   (pos-name rule36b-overruled-gen1894)
   (depends-on declare lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule36b] ) ) ) ?gen631 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen630 & : ( >= ?gen630 1 ) ) ) ?gen633 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ( positive ?gen632 & : ( >= ?gen632 1 ) ) ) ?gen624 <- ( crime_art150_2 ( defendant ?Defendant ) ( negative-support $?gen627 ) ( negative-overruled $?gen628 & : ( not ( subseq-pos ( create$ rule36b-overruled $?gen627 $$$ $?gen628 ) ) ) ) ( positive-defeated $?gen626 & : ( not ( member$ rule36b $?gen626 ) ) ) ) ( test ( eq ( class ?gen624 ) crime_art150_2 ) ) => ( calc ( bind $?gen629 ( create$ rule36b-overruled $?gen627 $?gen628 ) ) ) ?gen624 <- ( crime_art150_2 ( negative-overruled $?gen629 ) )"))

([rule36b-support] of derived-attribute-rule
   (pos-name rule36b-support-gen1896)
   (depends-on declare lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule36b] ) ) ) ?gen622 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen623 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ?gen624 <- ( crime_art150_2 ( defendant ?Defendant ) ( positive-support $?gen626 & : ( not ( subseq-pos ( create$ rule36b ?gen622 ?gen623 $$$ $?gen626 ) ) ) ) ) ( test ( eq ( class ?gen624 ) crime_art150_2 ) ) => ( calc ( bind $?gen629 ( create$ rule36b ?gen622 ?gen623 $?gen626 ) ) ) ?gen624 <- ( crime_art150_2 ( positive-support $?gen629 ) )"))

([rule34b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule34b-defeasibly-dot-gen1898)
   (depends-on declare crime_art150_1 lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule34b] ) ) ) ?gen610 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule34b $? ) ) ( test ( eq ( class ?gen610 ) crime_art150_1 ) ) ( not ( and ?gen617 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen616 & : ( >= ?gen616 1 ) ) ) ?gen619 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen618 & : ( >= ?gen618 1 ) ) ) ?gen621 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ( positive ?gen620 & : ( >= ?gen620 1 ) ) ) ?gen610 <- ( crime_art150_1 ( negative ~ 2 ) ( positive-overruled $?gen612 & : ( not ( member$ rule34b $?gen612 ) ) ) ) ) ) => ?gen610 <- ( crime_art150_1 ( positive 0 ) )"))

([rule34b-defeasibly] of derived-attribute-rule
   (pos-name rule34b-defeasibly-gen1900)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule34b] ) ) ) ?gen617 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen616 & : ( >= ?gen616 1 ) ) ) ?gen619 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen618 & : ( >= ?gen618 1 ) ) ) ?gen621 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ( positive ?gen620 & : ( >= ?gen620 1 ) ) ) ?gen610 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen612 & : ( not ( member$ rule34b $?gen612 ) ) ) ) ( test ( eq ( class ?gen610 ) crime_art150_1 ) ) => ?gen610 <- ( crime_art150_1 ( positive 1 ) ( positive-derivator rule34b ?gen617 ?gen619 ?gen621 ) )"))

([rule34b-overruled-dot] of derived-attribute-rule
   (pos-name rule34b-overruled-dot-gen1902)
   (depends-on declare crime_art150_1 lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule34b] ) ) ) ?gen610 <- ( crime_art150_1 ( defendant ?Defendant ) ( negative-support $?gen613 ) ( negative-overruled $?gen614 & : ( subseq-pos ( create$ rule34b-overruled $?gen613 $$$ $?gen614 ) ) ) ) ( test ( eq ( class ?gen610 ) crime_art150_1 ) ) ( not ( and ?gen617 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen616 & : ( >= ?gen616 1 ) ) ) ?gen619 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen618 & : ( >= ?gen618 1 ) ) ) ?gen621 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ( positive ?gen620 & : ( >= ?gen620 1 ) ) ) ?gen610 <- ( crime_art150_1 ( positive-defeated $?gen612 & : ( not ( member$ rule34b $?gen612 ) ) ) ) ) ) => ( calc ( bind $?gen615 ( delete-member$ $?gen614 ( create$ rule34b-overruled $?gen613 ) ) ) ) ?gen610 <- ( crime_art150_1 ( negative-overruled $?gen615 ) )"))

([rule34b-overruled] of derived-attribute-rule
   (pos-name rule34b-overruled-gen1904)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule34b] ) ) ) ?gen617 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen616 & : ( >= ?gen616 1 ) ) ) ?gen619 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen618 & : ( >= ?gen618 1 ) ) ) ?gen621 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ( positive ?gen620 & : ( >= ?gen620 1 ) ) ) ?gen610 <- ( crime_art150_1 ( defendant ?Defendant ) ( negative-support $?gen613 ) ( negative-overruled $?gen614 & : ( not ( subseq-pos ( create$ rule34b-overruled $?gen613 $$$ $?gen614 ) ) ) ) ( positive-defeated $?gen612 & : ( not ( member$ rule34b $?gen612 ) ) ) ) ( test ( eq ( class ?gen610 ) crime_art150_1 ) ) => ( calc ( bind $?gen615 ( create$ rule34b-overruled $?gen613 $?gen614 ) ) ) ?gen610 <- ( crime_art150_1 ( negative-overruled $?gen615 ) )"))

([rule34b-support] of derived-attribute-rule
   (pos-name rule34b-support-gen1906)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule34b] ) ) ) ?gen607 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen608 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen609 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ?gen610 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive-support $?gen612 & : ( not ( subseq-pos ( create$ rule34b ?gen607 ?gen608 ?gen609 $$$ $?gen612 ) ) ) ) ) ( test ( eq ( class ?gen610 ) crime_art150_1 ) ) => ( calc ( bind $?gen615 ( create$ rule34b ?gen607 ?gen608 ?gen609 $?gen612 ) ) ) ?gen610 <- ( crime_art150_1 ( positive-support $?gen615 ) )"))

([rule34-defeasibly-dot] of derived-attribute-rule
   (pos-name rule34-defeasibly-dot-gen1908)
   (depends-on declare crime_art150_1 lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule34] ) ) ) ?gen595 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule34 $? ) ) ( test ( eq ( class ?gen595 ) crime_art150_1 ) ) ( not ( and ?gen602 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen601 & : ( >= ?gen601 1 ) ) ) ?gen604 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen603 & : ( >= ?gen603 1 ) ) ) ?gen606 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ( positive ?gen605 & : ( >= ?gen605 1 ) ) ) ?gen595 <- ( crime_art150_1 ( negative ~ 2 ) ( positive-overruled $?gen597 & : ( not ( member$ rule34 $?gen597 ) ) ) ) ) ) => ?gen595 <- ( crime_art150_1 ( positive 0 ) )"))

([rule34-defeasibly] of derived-attribute-rule
   (pos-name rule34-defeasibly-gen1910)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule34] ) ) ) ?gen602 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen601 & : ( >= ?gen601 1 ) ) ) ?gen604 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen603 & : ( >= ?gen603 1 ) ) ) ?gen606 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ( positive ?gen605 & : ( >= ?gen605 1 ) ) ) ?gen595 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen597 & : ( not ( member$ rule34 $?gen597 ) ) ) ) ( test ( eq ( class ?gen595 ) crime_art150_1 ) ) => ?gen595 <- ( crime_art150_1 ( positive 1 ) ( positive-derivator rule34 ?gen602 ?gen604 ?gen606 ) )"))

([rule34-overruled-dot] of derived-attribute-rule
   (pos-name rule34-overruled-dot-gen1912)
   (depends-on declare crime_art150_1 lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule34] ) ) ) ?gen595 <- ( crime_art150_1 ( defendant ?Defendant ) ( negative-support $?gen598 ) ( negative-overruled $?gen599 & : ( subseq-pos ( create$ rule34-overruled $?gen598 $$$ $?gen599 ) ) ) ) ( test ( eq ( class ?gen595 ) crime_art150_1 ) ) ( not ( and ?gen602 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen601 & : ( >= ?gen601 1 ) ) ) ?gen604 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen603 & : ( >= ?gen603 1 ) ) ) ?gen606 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ( positive ?gen605 & : ( >= ?gen605 1 ) ) ) ?gen595 <- ( crime_art150_1 ( positive-defeated $?gen597 & : ( not ( member$ rule34 $?gen597 ) ) ) ) ) ) => ( calc ( bind $?gen600 ( delete-member$ $?gen599 ( create$ rule34-overruled $?gen598 ) ) ) ) ?gen595 <- ( crime_art150_1 ( negative-overruled $?gen600 ) )"))

([rule34-overruled] of derived-attribute-rule
   (pos-name rule34-overruled-gen1914)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule34] ) ) ) ?gen602 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ( positive ?gen601 & : ( >= ?gen601 1 ) ) ) ?gen604 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ( positive ?gen603 & : ( >= ?gen603 1 ) ) ) ?gen606 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ( positive ?gen605 & : ( >= ?gen605 1 ) ) ) ?gen595 <- ( crime_art150_1 ( defendant ?Defendant ) ( negative-support $?gen598 ) ( negative-overruled $?gen599 & : ( not ( subseq-pos ( create$ rule34-overruled $?gen598 $$$ $?gen599 ) ) ) ) ( positive-defeated $?gen597 & : ( not ( member$ rule34 $?gen597 ) ) ) ) ( test ( eq ( class ?gen595 ) crime_art150_1 ) ) => ( calc ( bind $?gen600 ( create$ rule34-overruled $?gen598 $?gen599 ) ) ) ?gen595 <- ( crime_art150_1 ( negative-overruled $?gen600 ) )"))

([rule34-support] of derived-attribute-rule
   (pos-name rule34-support-gen1916)
   (depends-on declare lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule34] ) ) ) ?gen592 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen593 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen594 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ?gen595 <- ( crime_art150_1 ( defendant ?Defendant ) ( positive-support $?gen597 & : ( not ( subseq-pos ( create$ rule34 ?gen592 ?gen593 ?gen594 $$$ $?gen597 ) ) ) ) ) ( test ( eq ( class ?gen595 ) crime_art150_1 ) ) => ( calc ( bind $?gen600 ( create$ rule34 ?gen592 ?gen593 ?gen594 $?gen597 ) ) ) ?gen595 <- ( crime_art150_1 ( positive-support $?gen600 ) )"))

([rule33-defeasibly-dot] of derived-attribute-rule
   (pos-name rule33-defeasibly-dot-gen1918)
   (depends-on declare crime_art149_5 lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule33] ) ) ) ?gen578 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule33 $? ) ) ( test ( eq ( class ?gen578 ) crime_art149_5 ) ) ( not ( and ?gen585 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen584 & : ( >= ?gen584 1 ) ) ) ?gen587 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen586 & : ( >= ?gen586 1 ) ) ) ?gen589 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen588 & : ( >= ?gen588 1 ) ) ) ?gen591 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen590 & : ( >= ?gen590 1 ) ) ) ?gen578 <- ( crime_art149_5 ( negative ~ 2 ) ( positive-overruled $?gen580 & : ( not ( member$ rule33 $?gen580 ) ) ) ) ) ) => ?gen578 <- ( crime_art149_5 ( positive 0 ) )"))

([rule33-defeasibly] of derived-attribute-rule
   (pos-name rule33-defeasibly-gen1920)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule33] ) ) ) ?gen585 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen584 & : ( >= ?gen584 1 ) ) ) ?gen587 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen586 & : ( >= ?gen586 1 ) ) ) ?gen589 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen588 & : ( >= ?gen588 1 ) ) ) ?gen591 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen590 & : ( >= ?gen590 1 ) ) ) ?gen578 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen580 & : ( not ( member$ rule33 $?gen580 ) ) ) ) ( test ( eq ( class ?gen578 ) crime_art149_5 ) ) => ?gen578 <- ( crime_art149_5 ( positive 1 ) ( positive-derivator rule33 ?gen585 ?gen587 ?gen589 ?gen591 ) )"))

([rule33-overruled-dot] of derived-attribute-rule
   (pos-name rule33-overruled-dot-gen1922)
   (depends-on declare crime_art149_5 lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule33] ) ) ) ?gen578 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen581 ) ( negative-overruled $?gen582 & : ( subseq-pos ( create$ rule33-overruled $?gen581 $$$ $?gen582 ) ) ) ) ( test ( eq ( class ?gen578 ) crime_art149_5 ) ) ( not ( and ?gen585 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen584 & : ( >= ?gen584 1 ) ) ) ?gen587 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen586 & : ( >= ?gen586 1 ) ) ) ?gen589 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen588 & : ( >= ?gen588 1 ) ) ) ?gen591 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen590 & : ( >= ?gen590 1 ) ) ) ?gen578 <- ( crime_art149_5 ( positive-defeated $?gen580 & : ( not ( member$ rule33 $?gen580 ) ) ) ) ) ) => ( calc ( bind $?gen583 ( delete-member$ $?gen582 ( create$ rule33-overruled $?gen581 ) ) ) ) ?gen578 <- ( crime_art149_5 ( negative-overruled $?gen583 ) )"))

([rule33-overruled] of derived-attribute-rule
   (pos-name rule33-overruled-gen1924)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule33] ) ) ) ?gen585 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen584 & : ( >= ?gen584 1 ) ) ) ?gen587 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen586 & : ( >= ?gen586 1 ) ) ) ?gen589 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen588 & : ( >= ?gen588 1 ) ) ) ?gen591 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen590 & : ( >= ?gen590 1 ) ) ) ?gen578 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen581 ) ( negative-overruled $?gen582 & : ( not ( subseq-pos ( create$ rule33-overruled $?gen581 $$$ $?gen582 ) ) ) ) ( positive-defeated $?gen580 & : ( not ( member$ rule33 $?gen580 ) ) ) ) ( test ( eq ( class ?gen578 ) crime_art149_5 ) ) => ( calc ( bind $?gen583 ( create$ rule33-overruled $?gen581 $?gen582 ) ) ) ?gen578 <- ( crime_art149_5 ( negative-overruled $?gen583 ) )"))

([rule33-support] of derived-attribute-rule
   (pos-name rule33-support-gen1926)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule33] ) ) ) ?gen574 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ?gen575 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ?gen576 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen577 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ?gen578 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive-support $?gen580 & : ( not ( subseq-pos ( create$ rule33 ?gen574 ?gen575 ?gen576 ?gen577 $$$ $?gen580 ) ) ) ) ) ( test ( eq ( class ?gen578 ) crime_art149_5 ) ) => ( calc ( bind $?gen583 ( create$ rule33 ?gen574 ?gen575 ?gen576 ?gen577 $?gen580 ) ) ) ?gen578 <- ( crime_art149_5 ( positive-support $?gen583 ) )"))

([rule32-defeasibly-dot] of derived-attribute-rule
   (pos-name rule32-defeasibly-dot-gen1928)
   (depends-on declare crime_art149_5 lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule32] ) ) ) ?gen560 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule32 $? ) ) ( test ( eq ( class ?gen560 ) crime_art149_5 ) ) ( not ( and ?gen567 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen566 & : ( >= ?gen566 1 ) ) ) ?gen569 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen568 & : ( >= ?gen568 1 ) ) ) ?gen571 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen570 & : ( >= ?gen570 1 ) ) ) ?gen573 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen572 & : ( >= ?gen572 1 ) ) ) ?gen560 <- ( crime_art149_5 ( negative ~ 2 ) ( positive-overruled $?gen562 & : ( not ( member$ rule32 $?gen562 ) ) ) ) ) ) => ?gen560 <- ( crime_art149_5 ( positive 0 ) )"))

([rule32-defeasibly] of derived-attribute-rule
   (pos-name rule32-defeasibly-gen1930)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule32] ) ) ) ?gen567 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen566 & : ( >= ?gen566 1 ) ) ) ?gen569 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen568 & : ( >= ?gen568 1 ) ) ) ?gen571 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen570 & : ( >= ?gen570 1 ) ) ) ?gen573 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen572 & : ( >= ?gen572 1 ) ) ) ?gen560 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen562 & : ( not ( member$ rule32 $?gen562 ) ) ) ) ( test ( eq ( class ?gen560 ) crime_art149_5 ) ) => ?gen560 <- ( crime_art149_5 ( positive 1 ) ( positive-derivator rule32 ?gen567 ?gen569 ?gen571 ?gen573 ) )"))

([rule32-overruled-dot] of derived-attribute-rule
   (pos-name rule32-overruled-dot-gen1932)
   (depends-on declare crime_art149_5 lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule32] ) ) ) ?gen560 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen563 ) ( negative-overruled $?gen564 & : ( subseq-pos ( create$ rule32-overruled $?gen563 $$$ $?gen564 ) ) ) ) ( test ( eq ( class ?gen560 ) crime_art149_5 ) ) ( not ( and ?gen567 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen566 & : ( >= ?gen566 1 ) ) ) ?gen569 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen568 & : ( >= ?gen568 1 ) ) ) ?gen571 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen570 & : ( >= ?gen570 1 ) ) ) ?gen573 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen572 & : ( >= ?gen572 1 ) ) ) ?gen560 <- ( crime_art149_5 ( positive-defeated $?gen562 & : ( not ( member$ rule32 $?gen562 ) ) ) ) ) ) => ( calc ( bind $?gen565 ( delete-member$ $?gen564 ( create$ rule32-overruled $?gen563 ) ) ) ) ?gen560 <- ( crime_art149_5 ( negative-overruled $?gen565 ) )"))

([rule32-overruled] of derived-attribute-rule
   (pos-name rule32-overruled-gen1934)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule32] ) ) ) ?gen567 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ( positive ?gen566 & : ( >= ?gen566 1 ) ) ) ?gen569 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ( positive ?gen568 & : ( >= ?gen568 1 ) ) ) ?gen571 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen570 & : ( >= ?gen570 1 ) ) ) ?gen573 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ( positive ?gen572 & : ( >= ?gen572 1 ) ) ) ?gen560 <- ( crime_art149_5 ( defendant ?Defendant ) ( negative-support $?gen563 ) ( negative-overruled $?gen564 & : ( not ( subseq-pos ( create$ rule32-overruled $?gen563 $$$ $?gen564 ) ) ) ) ( positive-defeated $?gen562 & : ( not ( member$ rule32 $?gen562 ) ) ) ) ( test ( eq ( class ?gen560 ) crime_art149_5 ) ) => ( calc ( bind $?gen565 ( create$ rule32-overruled $?gen563 $?gen564 ) ) ) ?gen560 <- ( crime_art149_5 ( negative-overruled $?gen565 ) )"))

([rule32-support] of derived-attribute-rule
   (pos-name rule32-support-gen1936)
   (depends-on declare lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule32] ) ) ) ?gen556 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ?gen557 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ?gen558 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen559 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ?gen560 <- ( crime_art149_5 ( defendant ?Defendant ) ( positive-support $?gen562 & : ( not ( subseq-pos ( create$ rule32 ?gen556 ?gen557 ?gen558 ?gen559 $$$ $?gen562 ) ) ) ) ) ( test ( eq ( class ?gen560 ) crime_art149_5 ) ) => ( calc ( bind $?gen565 ( create$ rule32 ?gen556 ?gen557 ?gen558 ?gen559 $?gen562 ) ) ) ?gen560 <- ( crime_art149_5 ( positive-support $?gen565 ) )"))

([rule31b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule31b-defeasibly-dot-gen1938)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule31b] ) ) ) ?gen544 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule31b $? ) ) ( test ( eq ( class ?gen544 ) crime_art144 ) ) ( not ( and ?gen551 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen550 & : ( >= ?gen550 1 ) ) ) ?gen553 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen552 & : ( >= ?gen552 1 ) ) ) ?gen555 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen554 & : ( >= ?gen554 1 ) ) ) ?gen544 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen546 & : ( not ( member$ rule31b $?gen546 ) ) ) ) ) ) => ?gen544 <- ( crime_art144 ( positive 0 ) )"))

([rule31b-defeasibly] of derived-attribute-rule
   (pos-name rule31b-defeasibly-gen1940)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule31b] ) ) ) ?gen551 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen550 & : ( >= ?gen550 1 ) ) ) ?gen553 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen552 & : ( >= ?gen552 1 ) ) ) ?gen555 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen554 & : ( >= ?gen554 1 ) ) ) ?gen544 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen546 & : ( not ( member$ rule31b $?gen546 ) ) ) ) ( test ( eq ( class ?gen544 ) crime_art144 ) ) => ?gen544 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule31b ?gen551 ?gen553 ?gen555 ) )"))

([rule31b-overruled-dot] of derived-attribute-rule
   (pos-name rule31b-overruled-dot-gen1942)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule31b] ) ) ) ?gen544 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen547 ) ( negative-overruled $?gen548 & : ( subseq-pos ( create$ rule31b-overruled $?gen547 $$$ $?gen548 ) ) ) ) ( test ( eq ( class ?gen544 ) crime_art144 ) ) ( not ( and ?gen551 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen550 & : ( >= ?gen550 1 ) ) ) ?gen553 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen552 & : ( >= ?gen552 1 ) ) ) ?gen555 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen554 & : ( >= ?gen554 1 ) ) ) ?gen544 <- ( crime_art144 ( positive-defeated $?gen546 & : ( not ( member$ rule31b $?gen546 ) ) ) ) ) ) => ( calc ( bind $?gen549 ( delete-member$ $?gen548 ( create$ rule31b-overruled $?gen547 ) ) ) ) ?gen544 <- ( crime_art144 ( negative-overruled $?gen549 ) )"))

([rule31b-overruled] of derived-attribute-rule
   (pos-name rule31b-overruled-gen1944)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule31b] ) ) ) ?gen551 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen550 & : ( >= ?gen550 1 ) ) ) ?gen553 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen552 & : ( >= ?gen552 1 ) ) ) ?gen555 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen554 & : ( >= ?gen554 1 ) ) ) ?gen544 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen547 ) ( negative-overruled $?gen548 & : ( not ( subseq-pos ( create$ rule31b-overruled $?gen547 $$$ $?gen548 ) ) ) ) ( positive-defeated $?gen546 & : ( not ( member$ rule31b $?gen546 ) ) ) ) ( test ( eq ( class ?gen544 ) crime_art144 ) ) => ( calc ( bind $?gen549 ( create$ rule31b-overruled $?gen547 $?gen548 ) ) ) ?gen544 <- ( crime_art144 ( negative-overruled $?gen549 ) )"))

([rule31b-support] of derived-attribute-rule
   (pos-name rule31b-support-gen1946)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule31b] ) ) ) ?gen541 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen542 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen543 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen544 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen546 & : ( not ( subseq-pos ( create$ rule31b ?gen541 ?gen542 ?gen543 $$$ $?gen546 ) ) ) ) ) ( test ( eq ( class ?gen544 ) crime_art144 ) ) => ( calc ( bind $?gen549 ( create$ rule31b ?gen541 ?gen542 ?gen543 $?gen546 ) ) ) ?gen544 <- ( crime_art144 ( positive-support $?gen549 ) )"))

([rule31-defeasibly-dot] of derived-attribute-rule
   (pos-name rule31-defeasibly-dot-gen1948)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule31] ) ) ) ?gen529 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule31 $? ) ) ( test ( eq ( class ?gen529 ) crime_art149_4 ) ) ( not ( and ?gen536 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen535 & : ( >= ?gen535 1 ) ) ) ?gen538 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen537 & : ( >= ?gen537 1 ) ) ) ?gen540 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen539 & : ( >= ?gen539 1 ) ) ) ?gen529 <- ( crime_art149_4 ( negative ~ 2 ) ( positive-overruled $?gen531 & : ( not ( member$ rule31 $?gen531 ) ) ) ) ) ) => ?gen529 <- ( crime_art149_4 ( positive 0 ) )"))

([rule31-defeasibly] of derived-attribute-rule
   (pos-name rule31-defeasibly-gen1950)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule31] ) ) ) ?gen536 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen535 & : ( >= ?gen535 1 ) ) ) ?gen538 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen537 & : ( >= ?gen537 1 ) ) ) ?gen540 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen539 & : ( >= ?gen539 1 ) ) ) ?gen529 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen531 & : ( not ( member$ rule31 $?gen531 ) ) ) ) ( test ( eq ( class ?gen529 ) crime_art149_4 ) ) => ?gen529 <- ( crime_art149_4 ( positive 1 ) ( positive-derivator rule31 ?gen536 ?gen538 ?gen540 ) )"))

([rule31-overruled-dot] of derived-attribute-rule
   (pos-name rule31-overruled-dot-gen1952)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule31] ) ) ) ?gen529 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen532 ) ( negative-overruled $?gen533 & : ( subseq-pos ( create$ rule31-overruled $?gen532 $$$ $?gen533 ) ) ) ) ( test ( eq ( class ?gen529 ) crime_art149_4 ) ) ( not ( and ?gen536 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen535 & : ( >= ?gen535 1 ) ) ) ?gen538 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen537 & : ( >= ?gen537 1 ) ) ) ?gen540 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen539 & : ( >= ?gen539 1 ) ) ) ?gen529 <- ( crime_art149_4 ( positive-defeated $?gen531 & : ( not ( member$ rule31 $?gen531 ) ) ) ) ) ) => ( calc ( bind $?gen534 ( delete-member$ $?gen533 ( create$ rule31-overruled $?gen532 ) ) ) ) ?gen529 <- ( crime_art149_4 ( negative-overruled $?gen534 ) )"))

([rule31-overruled] of derived-attribute-rule
   (pos-name rule31-overruled-gen1954)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule31] ) ) ) ?gen536 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen535 & : ( >= ?gen535 1 ) ) ) ?gen538 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( positive ?gen537 & : ( >= ?gen537 1 ) ) ) ?gen540 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen539 & : ( >= ?gen539 1 ) ) ) ?gen529 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen532 ) ( negative-overruled $?gen533 & : ( not ( subseq-pos ( create$ rule31-overruled $?gen532 $$$ $?gen533 ) ) ) ) ( positive-defeated $?gen531 & : ( not ( member$ rule31 $?gen531 ) ) ) ) ( test ( eq ( class ?gen529 ) crime_art149_4 ) ) => ( calc ( bind $?gen534 ( create$ rule31-overruled $?gen532 $?gen533 ) ) ) ?gen529 <- ( crime_art149_4 ( negative-overruled $?gen534 ) )"))

([rule31-support] of derived-attribute-rule
   (pos-name rule31-support-gen1956)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule31] ) ) ) ?gen526 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen527 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen528 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen529 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive-support $?gen531 & : ( not ( subseq-pos ( create$ rule31 ?gen526 ?gen527 ?gen528 $$$ $?gen531 ) ) ) ) ) ( test ( eq ( class ?gen529 ) crime_art149_4 ) ) => ( calc ( bind $?gen534 ( create$ rule31 ?gen526 ?gen527 ?gen528 $?gen531 ) ) ) ?gen529 <- ( crime_art149_4 ( positive-support $?gen534 ) )"))

([rule30b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule30b-defeasibly-dot-gen1958)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule30b] ) ) ) ?gen514 <- ( crime_art144 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule30b $? ) ) ( test ( eq ( class ?gen514 ) crime_art144 ) ) ( not ( and ?gen521 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen520 & : ( >= ?gen520 1 ) ) ) ?gen523 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen522 & : ( >= ?gen522 1 ) ) ) ?gen525 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen524 & : ( >= ?gen524 1 ) ) ) ?gen514 <- ( crime_art144 ( negative ~ 2 ) ( positive-overruled $?gen516 & : ( not ( member$ rule30b $?gen516 ) ) ) ) ) ) => ?gen514 <- ( crime_art144 ( positive 0 ) )"))

([rule30b-defeasibly] of derived-attribute-rule
   (pos-name rule30b-defeasibly-gen1960)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule30b] ) ) ) ?gen521 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen520 & : ( >= ?gen520 1 ) ) ) ?gen523 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen522 & : ( >= ?gen522 1 ) ) ) ?gen525 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen524 & : ( >= ?gen524 1 ) ) ) ?gen514 <- ( crime_art144 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen516 & : ( not ( member$ rule30b $?gen516 ) ) ) ) ( test ( eq ( class ?gen514 ) crime_art144 ) ) => ?gen514 <- ( crime_art144 ( positive 1 ) ( positive-derivator rule30b ?gen521 ?gen523 ?gen525 ) )"))

([rule30b-overruled-dot] of derived-attribute-rule
   (pos-name rule30b-overruled-dot-gen1962)
   (depends-on declare crime_art144 lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule30b] ) ) ) ?gen514 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen517 ) ( negative-overruled $?gen518 & : ( subseq-pos ( create$ rule30b-overruled $?gen517 $$$ $?gen518 ) ) ) ) ( test ( eq ( class ?gen514 ) crime_art144 ) ) ( not ( and ?gen521 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen520 & : ( >= ?gen520 1 ) ) ) ?gen523 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen522 & : ( >= ?gen522 1 ) ) ) ?gen525 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen524 & : ( >= ?gen524 1 ) ) ) ?gen514 <- ( crime_art144 ( positive-defeated $?gen516 & : ( not ( member$ rule30b $?gen516 ) ) ) ) ) ) => ( calc ( bind $?gen519 ( delete-member$ $?gen518 ( create$ rule30b-overruled $?gen517 ) ) ) ) ?gen514 <- ( crime_art144 ( negative-overruled $?gen519 ) )"))

([rule30b-overruled] of derived-attribute-rule
   (pos-name rule30b-overruled-gen1964)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule30b] ) ) ) ?gen521 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen520 & : ( >= ?gen520 1 ) ) ) ?gen523 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen522 & : ( >= ?gen522 1 ) ) ) ?gen525 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen524 & : ( >= ?gen524 1 ) ) ) ?gen514 <- ( crime_art144 ( defendant ?Defendant ) ( negative-support $?gen517 ) ( negative-overruled $?gen518 & : ( not ( subseq-pos ( create$ rule30b-overruled $?gen517 $$$ $?gen518 ) ) ) ) ( positive-defeated $?gen516 & : ( not ( member$ rule30b $?gen516 ) ) ) ) ( test ( eq ( class ?gen514 ) crime_art144 ) ) => ( calc ( bind $?gen519 ( create$ rule30b-overruled $?gen517 $?gen518 ) ) ) ?gen514 <- ( crime_art144 ( negative-overruled $?gen519 ) )"))

([rule30b-support] of derived-attribute-rule
   (pos-name rule30b-support-gen1966)
   (depends-on declare lc:case lc:case or crime_art144)
   (implies crime_art144)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule30b] ) ) ) ?gen511 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen512 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen513 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen514 <- ( crime_art144 ( defendant ?Defendant ) ( positive-support $?gen516 & : ( not ( subseq-pos ( create$ rule30b ?gen511 ?gen512 ?gen513 $$$ $?gen516 ) ) ) ) ) ( test ( eq ( class ?gen514 ) crime_art144 ) ) => ( calc ( bind $?gen519 ( create$ rule30b ?gen511 ?gen512 ?gen513 $?gen516 ) ) ) ?gen514 <- ( crime_art144 ( positive-support $?gen519 ) )"))

([rule30-defeasibly-dot] of derived-attribute-rule
   (pos-name rule30-defeasibly-dot-gen1968)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule30] ) ) ) ?gen499 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule30 $? ) ) ( test ( eq ( class ?gen499 ) crime_art149_4 ) ) ( not ( and ?gen506 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen505 & : ( >= ?gen505 1 ) ) ) ?gen508 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen507 & : ( >= ?gen507 1 ) ) ) ?gen510 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen509 & : ( >= ?gen509 1 ) ) ) ?gen499 <- ( crime_art149_4 ( negative ~ 2 ) ( positive-overruled $?gen501 & : ( not ( member$ rule30 $?gen501 ) ) ) ) ) ) => ?gen499 <- ( crime_art149_4 ( positive 0 ) )"))

([rule30-defeasibly] of derived-attribute-rule
   (pos-name rule30-defeasibly-gen1970)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule30] ) ) ) ?gen506 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen505 & : ( >= ?gen505 1 ) ) ) ?gen508 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen507 & : ( >= ?gen507 1 ) ) ) ?gen510 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen509 & : ( >= ?gen509 1 ) ) ) ?gen499 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen501 & : ( not ( member$ rule30 $?gen501 ) ) ) ) ( test ( eq ( class ?gen499 ) crime_art149_4 ) ) => ?gen499 <- ( crime_art149_4 ( positive 1 ) ( positive-derivator rule30 ?gen506 ?gen508 ?gen510 ) )"))

([rule30-overruled-dot] of derived-attribute-rule
   (pos-name rule30-overruled-dot-gen1972)
   (depends-on declare crime_art149_4 lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule30] ) ) ) ?gen499 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen502 ) ( negative-overruled $?gen503 & : ( subseq-pos ( create$ rule30-overruled $?gen502 $$$ $?gen503 ) ) ) ) ( test ( eq ( class ?gen499 ) crime_art149_4 ) ) ( not ( and ?gen506 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen505 & : ( >= ?gen505 1 ) ) ) ?gen508 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen507 & : ( >= ?gen507 1 ) ) ) ?gen510 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen509 & : ( >= ?gen509 1 ) ) ) ?gen499 <- ( crime_art149_4 ( positive-defeated $?gen501 & : ( not ( member$ rule30 $?gen501 ) ) ) ) ) ) => ( calc ( bind $?gen504 ( delete-member$ $?gen503 ( create$ rule30-overruled $?gen502 ) ) ) ) ?gen499 <- ( crime_art149_4 ( negative-overruled $?gen504 ) )"))

([rule30-overruled] of derived-attribute-rule
   (pos-name rule30-overruled-gen1974)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule30] ) ) ) ?gen506 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen505 & : ( >= ?gen505 1 ) ) ) ?gen508 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen507 & : ( >= ?gen507 1 ) ) ) ?gen510 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen509 & : ( >= ?gen509 1 ) ) ) ?gen499 <- ( crime_art149_4 ( defendant ?Defendant ) ( negative-support $?gen502 ) ( negative-overruled $?gen503 & : ( not ( subseq-pos ( create$ rule30-overruled $?gen502 $$$ $?gen503 ) ) ) ) ( positive-defeated $?gen501 & : ( not ( member$ rule30 $?gen501 ) ) ) ) ( test ( eq ( class ?gen499 ) crime_art149_4 ) ) => ( calc ( bind $?gen504 ( create$ rule30-overruled $?gen502 $?gen503 ) ) ) ?gen499 <- ( crime_art149_4 ( negative-overruled $?gen504 ) )"))

([rule30-support] of derived-attribute-rule
   (pos-name rule30-support-gen1976)
   (depends-on declare lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule30] ) ) ) ?gen496 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen497 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen498 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen499 <- ( crime_art149_4 ( defendant ?Defendant ) ( positive-support $?gen501 & : ( not ( subseq-pos ( create$ rule30 ?gen496 ?gen497 ?gen498 $$$ $?gen501 ) ) ) ) ) ( test ( eq ( class ?gen499 ) crime_art149_4 ) ) => ( calc ( bind $?gen504 ( create$ rule30 ?gen496 ?gen497 ?gen498 $?gen501 ) ) ) ?gen499 <- ( crime_art149_4 ( positive-support $?gen504 ) )"))

([rule29-defeasibly-dot] of derived-attribute-rule
   (pos-name rule29-defeasibly-dot-gen1978)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule29] ) ) ) ?gen484 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule29 $? ) ) ( test ( eq ( class ?gen484 ) crime_art149_3 ) ) ( not ( and ?gen491 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen490 & : ( >= ?gen490 1 ) ) ) ?gen493 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen492 & : ( >= ?gen492 1 ) ) ) ?gen495 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen494 & : ( >= ?gen494 1 ) ) ) ?gen484 <- ( crime_art149_3 ( negative ~ 2 ) ( positive-overruled $?gen486 & : ( not ( member$ rule29 $?gen486 ) ) ) ) ) ) => ?gen484 <- ( crime_art149_3 ( positive 0 ) )"))

([rule29-defeasibly] of derived-attribute-rule
   (pos-name rule29-defeasibly-gen1980)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule29] ) ) ) ?gen491 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen490 & : ( >= ?gen490 1 ) ) ) ?gen493 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen492 & : ( >= ?gen492 1 ) ) ) ?gen495 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen494 & : ( >= ?gen494 1 ) ) ) ?gen484 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen486 & : ( not ( member$ rule29 $?gen486 ) ) ) ) ( test ( eq ( class ?gen484 ) crime_art149_3 ) ) => ?gen484 <- ( crime_art149_3 ( positive 1 ) ( positive-derivator rule29 ?gen491 ?gen493 ?gen495 ) )"))

([rule29-overruled-dot] of derived-attribute-rule
   (pos-name rule29-overruled-dot-gen1982)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule29] ) ) ) ?gen484 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen487 ) ( negative-overruled $?gen488 & : ( subseq-pos ( create$ rule29-overruled $?gen487 $$$ $?gen488 ) ) ) ) ( test ( eq ( class ?gen484 ) crime_art149_3 ) ) ( not ( and ?gen491 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen490 & : ( >= ?gen490 1 ) ) ) ?gen493 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen492 & : ( >= ?gen492 1 ) ) ) ?gen495 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen494 & : ( >= ?gen494 1 ) ) ) ?gen484 <- ( crime_art149_3 ( positive-defeated $?gen486 & : ( not ( member$ rule29 $?gen486 ) ) ) ) ) ) => ( calc ( bind $?gen489 ( delete-member$ $?gen488 ( create$ rule29-overruled $?gen487 ) ) ) ) ?gen484 <- ( crime_art149_3 ( negative-overruled $?gen489 ) )"))

([rule29-overruled] of derived-attribute-rule
   (pos-name rule29-overruled-gen1984)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule29] ) ) ) ?gen491 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen490 & : ( >= ?gen490 1 ) ) ) ?gen493 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen492 & : ( >= ?gen492 1 ) ) ) ?gen495 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen494 & : ( >= ?gen494 1 ) ) ) ?gen484 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen487 ) ( negative-overruled $?gen488 & : ( not ( subseq-pos ( create$ rule29-overruled $?gen487 $$$ $?gen488 ) ) ) ) ( positive-defeated $?gen486 & : ( not ( member$ rule29 $?gen486 ) ) ) ) ( test ( eq ( class ?gen484 ) crime_art149_3 ) ) => ( calc ( bind $?gen489 ( create$ rule29-overruled $?gen487 $?gen488 ) ) ) ?gen484 <- ( crime_art149_3 ( negative-overruled $?gen489 ) )"))

([rule29-support] of derived-attribute-rule
   (pos-name rule29-support-gen1986)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule29] ) ) ) ?gen481 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen482 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen483 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen484 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive-support $?gen486 & : ( not ( subseq-pos ( create$ rule29 ?gen481 ?gen482 ?gen483 $$$ $?gen486 ) ) ) ) ) ( test ( eq ( class ?gen484 ) crime_art149_3 ) ) => ( calc ( bind $?gen489 ( create$ rule29 ?gen481 ?gen482 ?gen483 $?gen486 ) ) ) ?gen484 <- ( crime_art149_3 ( positive-support $?gen489 ) )"))

([rule28b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule28b-defeasibly-dot-gen1988)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule28b] ) ) ) ?gen469 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule28b $? ) ) ( test ( eq ( class ?gen469 ) crime_art149_3 ) ) ( not ( and ?gen476 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen475 & : ( >= ?gen475 1 ) ) ) ?gen478 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen477 & : ( >= ?gen477 1 ) ) ) ?gen480 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen479 & : ( >= ?gen479 1 ) ) ) ?gen469 <- ( crime_art149_3 ( negative ~ 2 ) ( positive-overruled $?gen471 & : ( not ( member$ rule28b $?gen471 ) ) ) ) ) ) => ?gen469 <- ( crime_art149_3 ( positive 0 ) )"))

([rule28b-defeasibly] of derived-attribute-rule
   (pos-name rule28b-defeasibly-gen1990)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule28b] ) ) ) ?gen476 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen475 & : ( >= ?gen475 1 ) ) ) ?gen478 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen477 & : ( >= ?gen477 1 ) ) ) ?gen480 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen479 & : ( >= ?gen479 1 ) ) ) ?gen469 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen471 & : ( not ( member$ rule28b $?gen471 ) ) ) ) ( test ( eq ( class ?gen469 ) crime_art149_3 ) ) => ?gen469 <- ( crime_art149_3 ( positive 1 ) ( positive-derivator rule28b ?gen476 ?gen478 ?gen480 ) )"))

([rule28b-overruled-dot] of derived-attribute-rule
   (pos-name rule28b-overruled-dot-gen1992)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule28b] ) ) ) ?gen469 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen472 ) ( negative-overruled $?gen473 & : ( subseq-pos ( create$ rule28b-overruled $?gen472 $$$ $?gen473 ) ) ) ) ( test ( eq ( class ?gen469 ) crime_art149_3 ) ) ( not ( and ?gen476 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen475 & : ( >= ?gen475 1 ) ) ) ?gen478 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen477 & : ( >= ?gen477 1 ) ) ) ?gen480 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen479 & : ( >= ?gen479 1 ) ) ) ?gen469 <- ( crime_art149_3 ( positive-defeated $?gen471 & : ( not ( member$ rule28b $?gen471 ) ) ) ) ) ) => ( calc ( bind $?gen474 ( delete-member$ $?gen473 ( create$ rule28b-overruled $?gen472 ) ) ) ) ?gen469 <- ( crime_art149_3 ( negative-overruled $?gen474 ) )"))

([rule28b-overruled] of derived-attribute-rule
   (pos-name rule28b-overruled-gen1994)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule28b] ) ) ) ?gen476 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen475 & : ( >= ?gen475 1 ) ) ) ?gen478 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen477 & : ( >= ?gen477 1 ) ) ) ?gen480 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen479 & : ( >= ?gen479 1 ) ) ) ?gen469 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen472 ) ( negative-overruled $?gen473 & : ( not ( subseq-pos ( create$ rule28b-overruled $?gen472 $$$ $?gen473 ) ) ) ) ( positive-defeated $?gen471 & : ( not ( member$ rule28b $?gen471 ) ) ) ) ( test ( eq ( class ?gen469 ) crime_art149_3 ) ) => ( calc ( bind $?gen474 ( create$ rule28b-overruled $?gen472 $?gen473 ) ) ) ?gen469 <- ( crime_art149_3 ( negative-overruled $?gen474 ) )"))

([rule28b-support] of derived-attribute-rule
   (pos-name rule28b-support-gen1996)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule28b] ) ) ) ?gen466 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen467 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen468 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen469 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive-support $?gen471 & : ( not ( subseq-pos ( create$ rule28b ?gen466 ?gen467 ?gen468 $$$ $?gen471 ) ) ) ) ) ( test ( eq ( class ?gen469 ) crime_art149_3 ) ) => ( calc ( bind $?gen474 ( create$ rule28b ?gen466 ?gen467 ?gen468 $?gen471 ) ) ) ?gen469 <- ( crime_art149_3 ( positive-support $?gen474 ) )"))

([rule28-defeasibly-dot] of derived-attribute-rule
   (pos-name rule28-defeasibly-dot-gen1998)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule28] ) ) ) ?gen454 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule28 $? ) ) ( test ( eq ( class ?gen454 ) crime_art149_3 ) ) ( not ( and ?gen461 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen460 & : ( >= ?gen460 1 ) ) ) ?gen463 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen462 & : ( >= ?gen462 1 ) ) ) ?gen465 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen464 & : ( >= ?gen464 1 ) ) ) ?gen454 <- ( crime_art149_3 ( negative ~ 2 ) ( positive-overruled $?gen456 & : ( not ( member$ rule28 $?gen456 ) ) ) ) ) ) => ?gen454 <- ( crime_art149_3 ( positive 0 ) )"))

([rule28-defeasibly] of derived-attribute-rule
   (pos-name rule28-defeasibly-gen2000)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule28] ) ) ) ?gen461 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen460 & : ( >= ?gen460 1 ) ) ) ?gen463 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen462 & : ( >= ?gen462 1 ) ) ) ?gen465 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen464 & : ( >= ?gen464 1 ) ) ) ?gen454 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen456 & : ( not ( member$ rule28 $?gen456 ) ) ) ) ( test ( eq ( class ?gen454 ) crime_art149_3 ) ) => ?gen454 <- ( crime_art149_3 ( positive 1 ) ( positive-derivator rule28 ?gen461 ?gen463 ?gen465 ) )"))

([rule28-overruled-dot] of derived-attribute-rule
   (pos-name rule28-overruled-dot-gen2002)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule28] ) ) ) ?gen454 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen457 ) ( negative-overruled $?gen458 & : ( subseq-pos ( create$ rule28-overruled $?gen457 $$$ $?gen458 ) ) ) ) ( test ( eq ( class ?gen454 ) crime_art149_3 ) ) ( not ( and ?gen461 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen460 & : ( >= ?gen460 1 ) ) ) ?gen463 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen462 & : ( >= ?gen462 1 ) ) ) ?gen465 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen464 & : ( >= ?gen464 1 ) ) ) ?gen454 <- ( crime_art149_3 ( positive-defeated $?gen456 & : ( not ( member$ rule28 $?gen456 ) ) ) ) ) ) => ( calc ( bind $?gen459 ( delete-member$ $?gen458 ( create$ rule28-overruled $?gen457 ) ) ) ) ?gen454 <- ( crime_art149_3 ( negative-overruled $?gen459 ) )"))

([rule28-overruled] of derived-attribute-rule
   (pos-name rule28-overruled-gen2004)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule28] ) ) ) ?gen461 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen460 & : ( >= ?gen460 1 ) ) ) ?gen463 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( positive ?gen462 & : ( >= ?gen462 1 ) ) ) ?gen465 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen464 & : ( >= ?gen464 1 ) ) ) ?gen454 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen457 ) ( negative-overruled $?gen458 & : ( not ( subseq-pos ( create$ rule28-overruled $?gen457 $$$ $?gen458 ) ) ) ) ( positive-defeated $?gen456 & : ( not ( member$ rule28 $?gen456 ) ) ) ) ( test ( eq ( class ?gen454 ) crime_art149_3 ) ) => ( calc ( bind $?gen459 ( create$ rule28-overruled $?gen457 $?gen458 ) ) ) ?gen454 <- ( crime_art149_3 ( negative-overruled $?gen459 ) )"))

([rule28-support] of derived-attribute-rule
   (pos-name rule28-support-gen2006)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule28] ) ) ) ?gen451 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen452 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen453 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen454 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive-support $?gen456 & : ( not ( subseq-pos ( create$ rule28 ?gen451 ?gen452 ?gen453 $$$ $?gen456 ) ) ) ) ) ( test ( eq ( class ?gen454 ) crime_art149_3 ) ) => ( calc ( bind $?gen459 ( create$ rule28 ?gen451 ?gen452 ?gen453 $?gen456 ) ) ) ?gen454 <- ( crime_art149_3 ( positive-support $?gen459 ) )"))

([rule29b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule29b-defeasibly-dot-gen2008)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule29b] ) ) ) ?gen439 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule29b $? ) ) ( test ( eq ( class ?gen439 ) crime_art149_3 ) ) ( not ( and ?gen446 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen445 & : ( >= ?gen445 1 ) ) ) ?gen448 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen447 & : ( >= ?gen447 1 ) ) ) ?gen450 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen449 & : ( >= ?gen449 1 ) ) ) ?gen439 <- ( crime_art149_3 ( negative ~ 2 ) ( positive-overruled $?gen441 & : ( not ( member$ rule29b $?gen441 ) ) ) ) ) ) => ?gen439 <- ( crime_art149_3 ( positive 0 ) )"))

([rule29b-defeasibly] of derived-attribute-rule
   (pos-name rule29b-defeasibly-gen2010)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule29b] ) ) ) ?gen446 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen445 & : ( >= ?gen445 1 ) ) ) ?gen448 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen447 & : ( >= ?gen447 1 ) ) ) ?gen450 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen449 & : ( >= ?gen449 1 ) ) ) ?gen439 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen441 & : ( not ( member$ rule29b $?gen441 ) ) ) ) ( test ( eq ( class ?gen439 ) crime_art149_3 ) ) => ?gen439 <- ( crime_art149_3 ( positive 1 ) ( positive-derivator rule29b ?gen446 ?gen448 ?gen450 ) )"))

([rule29b-overruled-dot] of derived-attribute-rule
   (pos-name rule29b-overruled-dot-gen2012)
   (depends-on declare crime_art149_3 lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule29b] ) ) ) ?gen439 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen442 ) ( negative-overruled $?gen443 & : ( subseq-pos ( create$ rule29b-overruled $?gen442 $$$ $?gen443 ) ) ) ) ( test ( eq ( class ?gen439 ) crime_art149_3 ) ) ( not ( and ?gen446 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen445 & : ( >= ?gen445 1 ) ) ) ?gen448 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen447 & : ( >= ?gen447 1 ) ) ) ?gen450 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen449 & : ( >= ?gen449 1 ) ) ) ?gen439 <- ( crime_art149_3 ( positive-defeated $?gen441 & : ( not ( member$ rule29b $?gen441 ) ) ) ) ) ) => ( calc ( bind $?gen444 ( delete-member$ $?gen443 ( create$ rule29b-overruled $?gen442 ) ) ) ) ?gen439 <- ( crime_art149_3 ( negative-overruled $?gen444 ) )"))

([rule29b-overruled] of derived-attribute-rule
   (pos-name rule29b-overruled-gen2014)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule29b] ) ) ) ?gen446 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen445 & : ( >= ?gen445 1 ) ) ) ?gen448 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( positive ?gen447 & : ( >= ?gen447 1 ) ) ) ?gen450 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( positive ?gen449 & : ( >= ?gen449 1 ) ) ) ?gen439 <- ( crime_art149_3 ( defendant ?Defendant ) ( negative-support $?gen442 ) ( negative-overruled $?gen443 & : ( not ( subseq-pos ( create$ rule29b-overruled $?gen442 $$$ $?gen443 ) ) ) ) ( positive-defeated $?gen441 & : ( not ( member$ rule29b $?gen441 ) ) ) ) ( test ( eq ( class ?gen439 ) crime_art149_3 ) ) => ( calc ( bind $?gen444 ( create$ rule29b-overruled $?gen442 $?gen443 ) ) ) ?gen439 <- ( crime_art149_3 ( negative-overruled $?gen444 ) )"))

([rule29b-support] of derived-attribute-rule
   (pos-name rule29b-support-gen2016)
   (depends-on declare lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule29b] ) ) ) ?gen436 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen437 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen438 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ?gen439 <- ( crime_art149_3 ( defendant ?Defendant ) ( positive-support $?gen441 & : ( not ( subseq-pos ( create$ rule29b ?gen436 ?gen437 ?gen438 $$$ $?gen441 ) ) ) ) ) ( test ( eq ( class ?gen439 ) crime_art149_3 ) ) => ( calc ( bind $?gen444 ( create$ rule29b ?gen436 ?gen437 ?gen438 $?gen441 ) ) ) ?gen439 <- ( crime_art149_3 ( positive-support $?gen444 ) )"))

([rule27-defeasibly-dot] of derived-attribute-rule
   (pos-name rule27-defeasibly-dot-gen2018)
   (depends-on declare crime_art149_2 lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule27] ) ) ) ?gen420 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule27 $? ) ) ( test ( eq ( class ?gen420 ) crime_art149_2 ) ) ( not ( and ?gen427 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen426 & : ( >= ?gen426 1 ) ) ) ?gen429 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen428 & : ( >= ?gen428 1 ) ) ) ?gen431 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen430 & : ( >= ?gen430 1 ) ) ) ?gen433 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen432 & : ( >= ?gen432 1 ) ) ) ?gen435 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen434 & : ( >= ?gen434 1 ) ) ) ?gen420 <- ( crime_art149_2 ( negative ~ 2 ) ( positive-overruled $?gen422 & : ( not ( member$ rule27 $?gen422 ) ) ) ) ) ) => ?gen420 <- ( crime_art149_2 ( positive 0 ) )"))

([rule27-defeasibly] of derived-attribute-rule
   (pos-name rule27-defeasibly-gen2020)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule27] ) ) ) ?gen427 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen426 & : ( >= ?gen426 1 ) ) ) ?gen429 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen428 & : ( >= ?gen428 1 ) ) ) ?gen431 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen430 & : ( >= ?gen430 1 ) ) ) ?gen433 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen432 & : ( >= ?gen432 1 ) ) ) ?gen435 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen434 & : ( >= ?gen434 1 ) ) ) ?gen420 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen422 & : ( not ( member$ rule27 $?gen422 ) ) ) ) ( test ( eq ( class ?gen420 ) crime_art149_2 ) ) => ?gen420 <- ( crime_art149_2 ( positive 1 ) ( positive-derivator rule27 ?gen427 ?gen429 ?gen431 ?gen433 ?gen435 ) )"))

([rule27-overruled-dot] of derived-attribute-rule
   (pos-name rule27-overruled-dot-gen2022)
   (depends-on declare crime_art149_2 lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule27] ) ) ) ?gen420 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen423 ) ( negative-overruled $?gen424 & : ( subseq-pos ( create$ rule27-overruled $?gen423 $$$ $?gen424 ) ) ) ) ( test ( eq ( class ?gen420 ) crime_art149_2 ) ) ( not ( and ?gen427 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen426 & : ( >= ?gen426 1 ) ) ) ?gen429 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen428 & : ( >= ?gen428 1 ) ) ) ?gen431 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen430 & : ( >= ?gen430 1 ) ) ) ?gen433 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen432 & : ( >= ?gen432 1 ) ) ) ?gen435 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen434 & : ( >= ?gen434 1 ) ) ) ?gen420 <- ( crime_art149_2 ( positive-defeated $?gen422 & : ( not ( member$ rule27 $?gen422 ) ) ) ) ) ) => ( calc ( bind $?gen425 ( delete-member$ $?gen424 ( create$ rule27-overruled $?gen423 ) ) ) ) ?gen420 <- ( crime_art149_2 ( negative-overruled $?gen425 ) )"))

([rule27-overruled] of derived-attribute-rule
   (pos-name rule27-overruled-gen2024)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule27] ) ) ) ?gen427 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen426 & : ( >= ?gen426 1 ) ) ) ?gen429 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen428 & : ( >= ?gen428 1 ) ) ) ?gen431 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen430 & : ( >= ?gen430 1 ) ) ) ?gen433 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen432 & : ( >= ?gen432 1 ) ) ) ?gen435 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen434 & : ( >= ?gen434 1 ) ) ) ?gen420 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen423 ) ( negative-overruled $?gen424 & : ( not ( subseq-pos ( create$ rule27-overruled $?gen423 $$$ $?gen424 ) ) ) ) ( positive-defeated $?gen422 & : ( not ( member$ rule27 $?gen422 ) ) ) ) ( test ( eq ( class ?gen420 ) crime_art149_2 ) ) => ( calc ( bind $?gen425 ( create$ rule27-overruled $?gen423 $?gen424 ) ) ) ?gen420 <- ( crime_art149_2 ( negative-overruled $?gen425 ) )"))

([rule27-support] of derived-attribute-rule
   (pos-name rule27-support-gen2026)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule27] ) ) ) ?gen415 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen416 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen417 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen418 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen419 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen420 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive-support $?gen422 & : ( not ( subseq-pos ( create$ rule27 ?gen415 ?gen416 ?gen417 ?gen418 ?gen419 $$$ $?gen422 ) ) ) ) ) ( test ( eq ( class ?gen420 ) crime_art149_2 ) ) => ( calc ( bind $?gen425 ( create$ rule27 ?gen415 ?gen416 ?gen417 ?gen418 ?gen419 $?gen422 ) ) ) ?gen420 <- ( crime_art149_2 ( positive-support $?gen425 ) )"))

([rule26-defeasibly-dot] of derived-attribute-rule
   (pos-name rule26-defeasibly-dot-gen2028)
   (depends-on declare crime_art149_2 lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule26] ) ) ) ?gen399 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule26 $? ) ) ( test ( eq ( class ?gen399 ) crime_art149_2 ) ) ( not ( and ?gen406 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen405 & : ( >= ?gen405 1 ) ) ) ?gen408 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen407 & : ( >= ?gen407 1 ) ) ) ?gen410 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen409 & : ( >= ?gen409 1 ) ) ) ?gen412 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen411 & : ( >= ?gen411 1 ) ) ) ?gen414 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen413 & : ( >= ?gen413 1 ) ) ) ?gen399 <- ( crime_art149_2 ( negative ~ 2 ) ( positive-overruled $?gen401 & : ( not ( member$ rule26 $?gen401 ) ) ) ) ) ) => ?gen399 <- ( crime_art149_2 ( positive 0 ) )"))

([rule26-defeasibly] of derived-attribute-rule
   (pos-name rule26-defeasibly-gen2030)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule26] ) ) ) ?gen406 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen405 & : ( >= ?gen405 1 ) ) ) ?gen408 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen407 & : ( >= ?gen407 1 ) ) ) ?gen410 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen409 & : ( >= ?gen409 1 ) ) ) ?gen412 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen411 & : ( >= ?gen411 1 ) ) ) ?gen414 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen413 & : ( >= ?gen413 1 ) ) ) ?gen399 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen401 & : ( not ( member$ rule26 $?gen401 ) ) ) ) ( test ( eq ( class ?gen399 ) crime_art149_2 ) ) => ?gen399 <- ( crime_art149_2 ( positive 1 ) ( positive-derivator rule26 ?gen406 ?gen408 ?gen410 ?gen412 ?gen414 ) )"))

([rule26-overruled-dot] of derived-attribute-rule
   (pos-name rule26-overruled-dot-gen2032)
   (depends-on declare crime_art149_2 lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule26] ) ) ) ?gen399 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen402 ) ( negative-overruled $?gen403 & : ( subseq-pos ( create$ rule26-overruled $?gen402 $$$ $?gen403 ) ) ) ) ( test ( eq ( class ?gen399 ) crime_art149_2 ) ) ( not ( and ?gen406 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen405 & : ( >= ?gen405 1 ) ) ) ?gen408 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen407 & : ( >= ?gen407 1 ) ) ) ?gen410 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen409 & : ( >= ?gen409 1 ) ) ) ?gen412 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen411 & : ( >= ?gen411 1 ) ) ) ?gen414 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen413 & : ( >= ?gen413 1 ) ) ) ?gen399 <- ( crime_art149_2 ( positive-defeated $?gen401 & : ( not ( member$ rule26 $?gen401 ) ) ) ) ) ) => ( calc ( bind $?gen404 ( delete-member$ $?gen403 ( create$ rule26-overruled $?gen402 ) ) ) ) ?gen399 <- ( crime_art149_2 ( negative-overruled $?gen404 ) )"))

([rule26-overruled] of derived-attribute-rule
   (pos-name rule26-overruled-gen2034)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule26] ) ) ) ?gen406 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ( positive ?gen405 & : ( >= ?gen405 1 ) ) ) ?gen408 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen407 & : ( >= ?gen407 1 ) ) ) ?gen410 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen409 & : ( >= ?gen409 1 ) ) ) ?gen412 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen411 & : ( >= ?gen411 1 ) ) ) ?gen414 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen413 & : ( >= ?gen413 1 ) ) ) ?gen399 <- ( crime_art149_2 ( defendant ?Defendant ) ( negative-support $?gen402 ) ( negative-overruled $?gen403 & : ( not ( subseq-pos ( create$ rule26-overruled $?gen402 $$$ $?gen403 ) ) ) ) ( positive-defeated $?gen401 & : ( not ( member$ rule26 $?gen401 ) ) ) ) ( test ( eq ( class ?gen399 ) crime_art149_2 ) ) => ( calc ( bind $?gen404 ( create$ rule26-overruled $?gen402 $?gen403 ) ) ) ?gen399 <- ( crime_art149_2 ( negative-overruled $?gen404 ) )"))

([rule26-support] of derived-attribute-rule
   (pos-name rule26-support-gen2036)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule26] ) ) ) ?gen394 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen395 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen396 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen397 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen398 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen399 <- ( crime_art149_2 ( defendant ?Defendant ) ( positive-support $?gen401 & : ( not ( subseq-pos ( create$ rule26 ?gen394 ?gen395 ?gen396 ?gen397 ?gen398 $$$ $?gen401 ) ) ) ) ) ( test ( eq ( class ?gen399 ) crime_art149_2 ) ) => ( calc ( bind $?gen404 ( create$ rule26 ?gen394 ?gen395 ?gen396 ?gen397 ?gen398 $?gen401 ) ) ) ?gen399 <- ( crime_art149_2 ( positive-support $?gen404 ) )"))

([rule25-defeasibly-dot] of derived-attribute-rule
   (pos-name rule25-defeasibly-dot-gen2038)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule25] ) ) ) ?gen376 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule25 $? ) ) ( test ( eq ( class ?gen376 ) crime_art149_1 ) ) ( not ( and ?gen383 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen382 & : ( >= ?gen382 1 ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen389 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen388 & : ( >= ?gen388 1 ) ) ) ?gen391 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen390 & : ( >= ?gen390 1 ) ) ) ?gen393 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen392 & : ( >= ?gen392 1 ) ) ) ?gen376 <- ( crime_art149_1 ( negative ~ 2 ) ( positive-overruled $?gen378 & : ( not ( member$ rule25 $?gen378 ) ) ) ) ) ) => ?gen376 <- ( crime_art149_1 ( positive 0 ) )"))

([rule25-defeasibly] of derived-attribute-rule
   (pos-name rule25-defeasibly-gen2040)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule25] ) ) ) ?gen383 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen382 & : ( >= ?gen382 1 ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen389 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen388 & : ( >= ?gen388 1 ) ) ) ?gen391 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen390 & : ( >= ?gen390 1 ) ) ) ?gen393 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen392 & : ( >= ?gen392 1 ) ) ) ?gen376 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen378 & : ( not ( member$ rule25 $?gen378 ) ) ) ) ( test ( eq ( class ?gen376 ) crime_art149_1 ) ) => ?gen376 <- ( crime_art149_1 ( positive 1 ) ( positive-derivator rule25 ?gen383 ?gen385 ?gen387 ?gen389 ?gen391 ?gen393 ) )"))

([rule25-overruled-dot] of derived-attribute-rule
   (pos-name rule25-overruled-dot-gen2042)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule25] ) ) ) ?gen376 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen379 ) ( negative-overruled $?gen380 & : ( subseq-pos ( create$ rule25-overruled $?gen379 $$$ $?gen380 ) ) ) ) ( test ( eq ( class ?gen376 ) crime_art149_1 ) ) ( not ( and ?gen383 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen382 & : ( >= ?gen382 1 ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen389 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen388 & : ( >= ?gen388 1 ) ) ) ?gen391 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen390 & : ( >= ?gen390 1 ) ) ) ?gen393 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen392 & : ( >= ?gen392 1 ) ) ) ?gen376 <- ( crime_art149_1 ( positive-defeated $?gen378 & : ( not ( member$ rule25 $?gen378 ) ) ) ) ) ) => ( calc ( bind $?gen381 ( delete-member$ $?gen380 ( create$ rule25-overruled $?gen379 ) ) ) ) ?gen376 <- ( crime_art149_1 ( negative-overruled $?gen381 ) )"))

([rule25-overruled] of derived-attribute-rule
   (pos-name rule25-overruled-gen2044)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule25] ) ) ) ?gen383 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen382 & : ( >= ?gen382 1 ) ) ) ?gen385 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ( positive ?gen384 & : ( >= ?gen384 1 ) ) ) ?gen387 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen386 & : ( >= ?gen386 1 ) ) ) ?gen389 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen388 & : ( >= ?gen388 1 ) ) ) ?gen391 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen390 & : ( >= ?gen390 1 ) ) ) ?gen393 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen392 & : ( >= ?gen392 1 ) ) ) ?gen376 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen379 ) ( negative-overruled $?gen380 & : ( not ( subseq-pos ( create$ rule25-overruled $?gen379 $$$ $?gen380 ) ) ) ) ( positive-defeated $?gen378 & : ( not ( member$ rule25 $?gen378 ) ) ) ) ( test ( eq ( class ?gen376 ) crime_art149_1 ) ) => ( calc ( bind $?gen381 ( create$ rule25-overruled $?gen379 $?gen380 ) ) ) ?gen376 <- ( crime_art149_1 ( negative-overruled $?gen381 ) )"))

([rule25-support] of derived-attribute-rule
   (pos-name rule25-support-gen2046)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule25] ) ) ) ?gen370 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen371 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen372 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen374 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen376 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive-support $?gen378 & : ( not ( subseq-pos ( create$ rule25 ?gen370 ?gen371 ?gen372 ?gen373 ?gen374 ?gen375 $$$ $?gen378 ) ) ) ) ) ( test ( eq ( class ?gen376 ) crime_art149_1 ) ) => ( calc ( bind $?gen381 ( create$ rule25 ?gen370 ?gen371 ?gen372 ?gen373 ?gen374 ?gen375 $?gen378 ) ) ) ?gen376 <- ( crime_art149_1 ( positive-support $?gen381 ) )"))

([rule24-defeasibly-dot] of derived-attribute-rule
   (pos-name rule24-defeasibly-dot-gen2048)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule24] ) ) ) ?gen352 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule24 $? ) ) ( test ( eq ( class ?gen352 ) crime_art149_1 ) ) ( not ( and ?gen359 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen358 & : ( >= ?gen358 1 ) ) ) ?gen361 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen360 & : ( >= ?gen360 1 ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen364 & : ( >= ?gen364 1 ) ) ) ?gen367 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen366 & : ( >= ?gen366 1 ) ) ) ?gen369 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen368 & : ( >= ?gen368 1 ) ) ) ?gen352 <- ( crime_art149_1 ( negative ~ 2 ) ( positive-overruled $?gen354 & : ( not ( member$ rule24 $?gen354 ) ) ) ) ) ) => ?gen352 <- ( crime_art149_1 ( positive 0 ) )"))

([rule24-defeasibly] of derived-attribute-rule
   (pos-name rule24-defeasibly-gen2050)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule24] ) ) ) ?gen359 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen358 & : ( >= ?gen358 1 ) ) ) ?gen361 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen360 & : ( >= ?gen360 1 ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen364 & : ( >= ?gen364 1 ) ) ) ?gen367 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen366 & : ( >= ?gen366 1 ) ) ) ?gen369 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen368 & : ( >= ?gen368 1 ) ) ) ?gen352 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen354 & : ( not ( member$ rule24 $?gen354 ) ) ) ) ( test ( eq ( class ?gen352 ) crime_art149_1 ) ) => ?gen352 <- ( crime_art149_1 ( positive 1 ) ( positive-derivator rule24 ?gen359 ?gen361 ?gen363 ?gen365 ?gen367 ?gen369 ) )"))

([rule24-overruled-dot] of derived-attribute-rule
   (pos-name rule24-overruled-dot-gen2052)
   (depends-on declare crime_art149_1 lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule24] ) ) ) ?gen352 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen355 ) ( negative-overruled $?gen356 & : ( subseq-pos ( create$ rule24-overruled $?gen355 $$$ $?gen356 ) ) ) ) ( test ( eq ( class ?gen352 ) crime_art149_1 ) ) ( not ( and ?gen359 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen358 & : ( >= ?gen358 1 ) ) ) ?gen361 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen360 & : ( >= ?gen360 1 ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen364 & : ( >= ?gen364 1 ) ) ) ?gen367 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen366 & : ( >= ?gen366 1 ) ) ) ?gen369 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen368 & : ( >= ?gen368 1 ) ) ) ?gen352 <- ( crime_art149_1 ( positive-defeated $?gen354 & : ( not ( member$ rule24 $?gen354 ) ) ) ) ) ) => ( calc ( bind $?gen357 ( delete-member$ $?gen356 ( create$ rule24-overruled $?gen355 ) ) ) ) ?gen352 <- ( crime_art149_1 ( negative-overruled $?gen357 ) )"))

([rule24-overruled] of derived-attribute-rule
   (pos-name rule24-overruled-gen2054)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule24] ) ) ) ?gen359 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ( positive ?gen358 & : ( >= ?gen358 1 ) ) ) ?gen361 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ( positive ?gen360 & : ( >= ?gen360 1 ) ) ) ?gen363 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( negative ?gen362 & : ( >= ?gen362 1 ) ) ) ?gen365 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ( negative ?gen364 & : ( >= ?gen364 1 ) ) ) ?gen367 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ( negative ?gen366 & : ( >= ?gen366 1 ) ) ) ?gen369 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ( negative ?gen368 & : ( >= ?gen368 1 ) ) ) ?gen352 <- ( crime_art149_1 ( defendant ?Defendant ) ( negative-support $?gen355 ) ( negative-overruled $?gen356 & : ( not ( subseq-pos ( create$ rule24-overruled $?gen355 $$$ $?gen356 ) ) ) ) ( positive-defeated $?gen354 & : ( not ( member$ rule24 $?gen354 ) ) ) ) ( test ( eq ( class ?gen352 ) crime_art149_1 ) ) => ( calc ( bind $?gen357 ( create$ rule24-overruled $?gen355 $?gen356 ) ) ) ?gen352 <- ( crime_art149_1 ( negative-overruled $?gen357 ) )"))

([rule24-support] of derived-attribute-rule
   (pos-name rule24-support-gen2056)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule24] ) ) ) ?gen346 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen347 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen348 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen349 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen351 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen352 <- ( crime_art149_1 ( defendant ?Defendant ) ( positive-support $?gen354 & : ( not ( subseq-pos ( create$ rule24 ?gen346 ?gen347 ?gen348 ?gen349 ?gen350 ?gen351 $$$ $?gen354 ) ) ) ) ) ( test ( eq ( class ?gen352 ) crime_art149_1 ) ) => ( calc ( bind $?gen357 ( create$ rule24 ?gen346 ?gen347 ?gen348 ?gen349 ?gen350 ?gen351 $?gen354 ) ) ) ?gen352 <- ( crime_art149_1 ( positive-support $?gen357 ) )"))

([rule22-defeasibly-dot] of derived-attribute-rule
   (pos-name rule22-defeasibly-dot-gen2058)
   (depends-on declare crime_art148 lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule22] ) ) ) ?gen336 <- ( crime_art148 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule22 $? ) ) ( test ( eq ( class ?gen336 ) crime_art148 ) ) ( not ( and ?gen343 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen342 & : ( >= ?gen342 1 ) ) ) ?gen345 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen344 & : ( >= ?gen344 1 ) ) ) ?gen336 <- ( crime_art148 ( negative ~ 2 ) ( positive-overruled $?gen338 & : ( not ( member$ rule22 $?gen338 ) ) ) ) ) ) => ?gen336 <- ( crime_art148 ( positive 0 ) )"))

([rule22-defeasibly] of derived-attribute-rule
   (pos-name rule22-defeasibly-gen2060)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule22] ) ) ) ?gen343 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen342 & : ( >= ?gen342 1 ) ) ) ?gen345 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen344 & : ( >= ?gen344 1 ) ) ) ?gen336 <- ( crime_art148 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen338 & : ( not ( member$ rule22 $?gen338 ) ) ) ) ( test ( eq ( class ?gen336 ) crime_art148 ) ) => ?gen336 <- ( crime_art148 ( positive 1 ) ( positive-derivator rule22 ?gen343 ?gen345 ) )"))

([rule22-overruled-dot] of derived-attribute-rule
   (pos-name rule22-overruled-dot-gen2062)
   (depends-on declare crime_art148 lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule22] ) ) ) ?gen336 <- ( crime_art148 ( defendant ?Defendant ) ( negative-support $?gen339 ) ( negative-overruled $?gen340 & : ( subseq-pos ( create$ rule22-overruled $?gen339 $$$ $?gen340 ) ) ) ) ( test ( eq ( class ?gen336 ) crime_art148 ) ) ( not ( and ?gen343 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen342 & : ( >= ?gen342 1 ) ) ) ?gen345 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen344 & : ( >= ?gen344 1 ) ) ) ?gen336 <- ( crime_art148 ( positive-defeated $?gen338 & : ( not ( member$ rule22 $?gen338 ) ) ) ) ) ) => ( calc ( bind $?gen341 ( delete-member$ $?gen340 ( create$ rule22-overruled $?gen339 ) ) ) ) ?gen336 <- ( crime_art148 ( negative-overruled $?gen341 ) )"))

([rule22-overruled] of derived-attribute-rule
   (pos-name rule22-overruled-gen2064)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule22] ) ) ) ?gen343 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen342 & : ( >= ?gen342 1 ) ) ) ?gen345 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ( positive ?gen344 & : ( >= ?gen344 1 ) ) ) ?gen336 <- ( crime_art148 ( defendant ?Defendant ) ( negative-support $?gen339 ) ( negative-overruled $?gen340 & : ( not ( subseq-pos ( create$ rule22-overruled $?gen339 $$$ $?gen340 ) ) ) ) ( positive-defeated $?gen338 & : ( not ( member$ rule22 $?gen338 ) ) ) ) ( test ( eq ( class ?gen336 ) crime_art148 ) ) => ( calc ( bind $?gen341 ( create$ rule22-overruled $?gen339 $?gen340 ) ) ) ?gen336 <- ( crime_art148 ( negative-overruled $?gen341 ) )"))

([rule22-support] of derived-attribute-rule
   (pos-name rule22-support-gen2066)
   (depends-on declare lc:case lc:case crime_art148)
   (implies crime_art148)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule22] ) ) ) ?gen334 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen335 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ?gen336 <- ( crime_art148 ( defendant ?Defendant ) ( positive-support $?gen338 & : ( not ( subseq-pos ( create$ rule22 ?gen334 ?gen335 $$$ $?gen338 ) ) ) ) ) ( test ( eq ( class ?gen336 ) crime_art148 ) ) => ( calc ( bind $?gen341 ( create$ rule22 ?gen334 ?gen335 $?gen338 ) ) ) ?gen336 <- ( crime_art148 ( positive-support $?gen341 ) )"))

([rule21-defeasibly-dot] of derived-attribute-rule
   (pos-name rule21-defeasibly-dot-gen2068)
   (depends-on declare crime_art147 lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule21] ) ) ) ?gen318 <- ( crime_art147 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule21 $? ) ) ( test ( eq ( class ?gen318 ) crime_art147 ) ) ( not ( and ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen328 & : ( >= ?gen328 1 ) ) ) ?gen331 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen330 & : ( >= ?gen330 1 ) ) ) ?gen333 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ( positive ?gen332 & : ( >= ?gen332 1 ) ) ) ?gen318 <- ( crime_art147 ( negative ~ 2 ) ( positive-overruled $?gen320 & : ( not ( member$ rule21 $?gen320 ) ) ) ) ) ) => ?gen318 <- ( crime_art147 ( positive 0 ) )"))

([rule21-defeasibly] of derived-attribute-rule
   (pos-name rule21-defeasibly-gen2070)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule21] ) ) ) ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen328 & : ( >= ?gen328 1 ) ) ) ?gen331 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen330 & : ( >= ?gen330 1 ) ) ) ?gen333 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ( positive ?gen332 & : ( >= ?gen332 1 ) ) ) ?gen318 <- ( crime_art147 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen320 & : ( not ( member$ rule21 $?gen320 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art147 ) ) => ?gen318 <- ( crime_art147 ( positive 1 ) ( positive-derivator rule21 ?gen325 ?gen327 ?gen329 ?gen331 ?gen333 ) )"))

([rule21-overruled-dot] of derived-attribute-rule
   (pos-name rule21-overruled-dot-gen2072)
   (depends-on declare crime_art147 lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule21] ) ) ) ?gen318 <- ( crime_art147 ( defendant ?Defendant ) ( negative-support $?gen321 ) ( negative-overruled $?gen322 & : ( subseq-pos ( create$ rule21-overruled $?gen321 $$$ $?gen322 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art147 ) ) ( not ( and ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen328 & : ( >= ?gen328 1 ) ) ) ?gen331 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen330 & : ( >= ?gen330 1 ) ) ) ?gen333 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ( positive ?gen332 & : ( >= ?gen332 1 ) ) ) ?gen318 <- ( crime_art147 ( positive-defeated $?gen320 & : ( not ( member$ rule21 $?gen320 ) ) ) ) ) ) => ( calc ( bind $?gen323 ( delete-member$ $?gen322 ( create$ rule21-overruled $?gen321 ) ) ) ) ?gen318 <- ( crime_art147 ( negative-overruled $?gen323 ) )"))

([rule21-overruled] of derived-attribute-rule
   (pos-name rule21-overruled-gen2074)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule21] ) ) ) ?gen325 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen324 & : ( >= ?gen324 1 ) ) ) ?gen327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ( positive ?gen326 & : ( >= ?gen326 1 ) ) ) ?gen329 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ( positive ?gen328 & : ( >= ?gen328 1 ) ) ) ?gen331 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ( positive ?gen330 & : ( >= ?gen330 1 ) ) ) ?gen333 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ( positive ?gen332 & : ( >= ?gen332 1 ) ) ) ?gen318 <- ( crime_art147 ( defendant ?Defendant ) ( negative-support $?gen321 ) ( negative-overruled $?gen322 & : ( not ( subseq-pos ( create$ rule21-overruled $?gen321 $$$ $?gen322 ) ) ) ) ( positive-defeated $?gen320 & : ( not ( member$ rule21 $?gen320 ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art147 ) ) => ( calc ( bind $?gen323 ( create$ rule21-overruled $?gen321 $?gen322 ) ) ) ?gen318 <- ( crime_art147 ( negative-overruled $?gen323 ) )"))

([rule21-support] of derived-attribute-rule
   (pos-name rule21-support-gen2076)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule21] ) ) ) ?gen313 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen314 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen316 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen317 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ?gen318 <- ( crime_art147 ( defendant ?Defendant ) ( positive-support $?gen320 & : ( not ( subseq-pos ( create$ rule21 ?gen313 ?gen314 ?gen315 ?gen316 ?gen317 $$$ $?gen320 ) ) ) ) ) ( test ( eq ( class ?gen318 ) crime_art147 ) ) => ( calc ( bind $?gen323 ( create$ rule21 ?gen313 ?gen314 ?gen315 ?gen316 ?gen317 $?gen320 ) ) ) ?gen318 <- ( crime_art147 ( positive-support $?gen323 ) )"))

([rule19-defeasibly-dot] of derived-attribute-rule
   (pos-name rule19-defeasibly-dot-gen2078)
   (depends-on declare crime_art146 lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule19] ) ) ) ?gen299 <- ( crime_art146 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule19 $? ) ) ( test ( eq ( class ?gen299 ) crime_art146 ) ) ( not ( and ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen308 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen307 & : ( >= ?gen307 1 ) ) ) ?gen310 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( positive ?gen309 & : ( >= ?gen309 1 ) ) ) ?gen312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen311 & : ( >= ?gen311 1 ) ) ) ?gen299 <- ( crime_art146 ( negative ~ 2 ) ( positive-overruled $?gen301 & : ( not ( member$ rule19 $?gen301 ) ) ) ) ) ) => ?gen299 <- ( crime_art146 ( positive 0 ) )"))

([rule19-defeasibly] of derived-attribute-rule
   (pos-name rule19-defeasibly-gen2080)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule19] ) ) ) ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen308 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen307 & : ( >= ?gen307 1 ) ) ) ?gen310 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( positive ?gen309 & : ( >= ?gen309 1 ) ) ) ?gen312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen311 & : ( >= ?gen311 1 ) ) ) ?gen299 <- ( crime_art146 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen301 & : ( not ( member$ rule19 $?gen301 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art146 ) ) => ?gen299 <- ( crime_art146 ( positive 1 ) ( positive-derivator rule19 ?gen306 ?gen308 ?gen310 ?gen312 ) )"))

([rule19-overruled-dot] of derived-attribute-rule
   (pos-name rule19-overruled-dot-gen2082)
   (depends-on declare crime_art146 lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule19] ) ) ) ?gen299 <- ( crime_art146 ( defendant ?Defendant ) ( negative-support $?gen302 ) ( negative-overruled $?gen303 & : ( subseq-pos ( create$ rule19-overruled $?gen302 $$$ $?gen303 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art146 ) ) ( not ( and ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen308 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen307 & : ( >= ?gen307 1 ) ) ) ?gen310 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( positive ?gen309 & : ( >= ?gen309 1 ) ) ) ?gen312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen311 & : ( >= ?gen311 1 ) ) ) ?gen299 <- ( crime_art146 ( positive-defeated $?gen301 & : ( not ( member$ rule19 $?gen301 ) ) ) ) ) ) => ( calc ( bind $?gen304 ( delete-member$ $?gen303 ( create$ rule19-overruled $?gen302 ) ) ) ) ?gen299 <- ( crime_art146 ( negative-overruled $?gen304 ) )"))

([rule19-overruled] of derived-attribute-rule
   (pos-name rule19-overruled-gen2084)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule19] ) ) ) ?gen306 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen305 & : ( >= ?gen305 1 ) ) ) ?gen308 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( positive ?gen307 & : ( >= ?gen307 1 ) ) ) ?gen310 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ( positive ?gen309 & : ( >= ?gen309 1 ) ) ) ?gen312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen311 & : ( >= ?gen311 1 ) ) ) ?gen299 <- ( crime_art146 ( defendant ?Defendant ) ( negative-support $?gen302 ) ( negative-overruled $?gen303 & : ( not ( subseq-pos ( create$ rule19-overruled $?gen302 $$$ $?gen303 ) ) ) ) ( positive-defeated $?gen301 & : ( not ( member$ rule19 $?gen301 ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art146 ) ) => ( calc ( bind $?gen304 ( create$ rule19-overruled $?gen302 $?gen303 ) ) ) ?gen299 <- ( crime_art146 ( negative-overruled $?gen304 ) )"))

([rule19-support] of derived-attribute-rule
   (pos-name rule19-support-gen2086)
   (depends-on declare lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule19] ) ) ) ?gen295 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen296 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ?gen298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen299 <- ( crime_art146 ( defendant ?Defendant ) ( positive-support $?gen301 & : ( not ( subseq-pos ( create$ rule19 ?gen295 ?gen296 ?gen297 ?gen298 $$$ $?gen301 ) ) ) ) ) ( test ( eq ( class ?gen299 ) crime_art146 ) ) => ( calc ( bind $?gen304 ( create$ rule19 ?gen295 ?gen296 ?gen297 ?gen298 $?gen301 ) ) ) ?gen299 <- ( crime_art146 ( positive-support $?gen304 ) )"))

([rule18b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule18b-defeasibly-dot-gen2088)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule18b] ) ) ) ?gen279 <- ( crime_art145 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule18b $? ) ) ( test ( eq ( class ?gen279 ) crime_art145 ) ) ( not ( and ?gen286 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen285 & : ( >= ?gen285 1 ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen290 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ( positive ?gen289 & : ( >= ?gen289 1 ) ) ) ?gen292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen291 & : ( >= ?gen291 1 ) ) ) ?gen294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen293 & : ( >= ?gen293 1 ) ) ) ?gen279 <- ( crime_art145 ( negative ~ 2 ) ( positive-overruled $?gen281 & : ( not ( member$ rule18b $?gen281 ) ) ) ) ) ) => ?gen279 <- ( crime_art145 ( positive 0 ) )"))

([rule18b-defeasibly] of derived-attribute-rule
   (pos-name rule18b-defeasibly-gen2090)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule18b] ) ) ) ?gen286 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen285 & : ( >= ?gen285 1 ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen290 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ( positive ?gen289 & : ( >= ?gen289 1 ) ) ) ?gen292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen291 & : ( >= ?gen291 1 ) ) ) ?gen294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen293 & : ( >= ?gen293 1 ) ) ) ?gen279 <- ( crime_art145 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen281 & : ( not ( member$ rule18b $?gen281 ) ) ) ) ( test ( eq ( class ?gen279 ) crime_art145 ) ) => ?gen279 <- ( crime_art145 ( positive 1 ) ( positive-derivator rule18b ?gen286 ?gen288 ?gen290 ?gen292 ?gen294 ) )"))

([rule18b-overruled-dot] of derived-attribute-rule
   (pos-name rule18b-overruled-dot-gen2092)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule18b] ) ) ) ?gen279 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen282 ) ( negative-overruled $?gen283 & : ( subseq-pos ( create$ rule18b-overruled $?gen282 $$$ $?gen283 ) ) ) ) ( test ( eq ( class ?gen279 ) crime_art145 ) ) ( not ( and ?gen286 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen285 & : ( >= ?gen285 1 ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen290 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ( positive ?gen289 & : ( >= ?gen289 1 ) ) ) ?gen292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen291 & : ( >= ?gen291 1 ) ) ) ?gen294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen293 & : ( >= ?gen293 1 ) ) ) ?gen279 <- ( crime_art145 ( positive-defeated $?gen281 & : ( not ( member$ rule18b $?gen281 ) ) ) ) ) ) => ( calc ( bind $?gen284 ( delete-member$ $?gen283 ( create$ rule18b-overruled $?gen282 ) ) ) ) ?gen279 <- ( crime_art145 ( negative-overruled $?gen284 ) )"))

([rule18b-overruled] of derived-attribute-rule
   (pos-name rule18b-overruled-gen2094)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule18b] ) ) ) ?gen286 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen285 & : ( >= ?gen285 1 ) ) ) ?gen288 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen287 & : ( >= ?gen287 1 ) ) ) ?gen290 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ( positive ?gen289 & : ( >= ?gen289 1 ) ) ) ?gen292 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen291 & : ( >= ?gen291 1 ) ) ) ?gen294 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen293 & : ( >= ?gen293 1 ) ) ) ?gen279 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen282 ) ( negative-overruled $?gen283 & : ( not ( subseq-pos ( create$ rule18b-overruled $?gen282 $$$ $?gen283 ) ) ) ) ( positive-defeated $?gen281 & : ( not ( member$ rule18b $?gen281 ) ) ) ) ( test ( eq ( class ?gen279 ) crime_art145 ) ) => ( calc ( bind $?gen284 ( create$ rule18b-overruled $?gen282 $?gen283 ) ) ) ?gen279 <- ( crime_art145 ( negative-overruled $?gen284 ) )"))

([rule18b-support] of derived-attribute-rule
   (pos-name rule18b-support-gen2096)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule18b] ) ) ) ?gen274 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen276 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen278 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen279 <- ( crime_art145 ( defendant ?Defendant ) ( positive-support $?gen281 & : ( not ( subseq-pos ( create$ rule18b ?gen274 ?gen275 ?gen276 ?gen277 ?gen278 $$$ $?gen281 ) ) ) ) ) ( test ( eq ( class ?gen279 ) crime_art145 ) ) => ( calc ( bind $?gen284 ( create$ rule18b ?gen274 ?gen275 ?gen276 ?gen277 ?gen278 $?gen281 ) ) ) ?gen279 <- ( crime_art145 ( positive-support $?gen284 ) )"))

([rule18-defeasibly-dot] of derived-attribute-rule
   (pos-name rule18-defeasibly-dot-gen2098)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule18] ) ) ) ?gen258 <- ( crime_art145 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule18 $? ) ) ( test ( eq ( class ?gen258 ) crime_art145 ) ) ( not ( and ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ( positive ?gen268 & : ( >= ?gen268 1 ) ) ) ?gen271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen270 & : ( >= ?gen270 1 ) ) ) ?gen273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen272 & : ( >= ?gen272 1 ) ) ) ?gen258 <- ( crime_art145 ( negative ~ 2 ) ( positive-overruled $?gen260 & : ( not ( member$ rule18 $?gen260 ) ) ) ) ) ) => ?gen258 <- ( crime_art145 ( positive 0 ) )"))

([rule18-defeasibly] of derived-attribute-rule
   (pos-name rule18-defeasibly-gen2100)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule18] ) ) ) ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ( positive ?gen268 & : ( >= ?gen268 1 ) ) ) ?gen271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen270 & : ( >= ?gen270 1 ) ) ) ?gen273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen272 & : ( >= ?gen272 1 ) ) ) ?gen258 <- ( crime_art145 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen260 & : ( not ( member$ rule18 $?gen260 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art145 ) ) => ?gen258 <- ( crime_art145 ( positive 1 ) ( positive-derivator rule18 ?gen265 ?gen267 ?gen269 ?gen271 ?gen273 ) )"))

([rule18-overruled-dot] of derived-attribute-rule
   (pos-name rule18-overruled-dot-gen2102)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule18] ) ) ) ?gen258 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen261 ) ( negative-overruled $?gen262 & : ( subseq-pos ( create$ rule18-overruled $?gen261 $$$ $?gen262 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art145 ) ) ( not ( and ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ( positive ?gen268 & : ( >= ?gen268 1 ) ) ) ?gen271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen270 & : ( >= ?gen270 1 ) ) ) ?gen273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen272 & : ( >= ?gen272 1 ) ) ) ?gen258 <- ( crime_art145 ( positive-defeated $?gen260 & : ( not ( member$ rule18 $?gen260 ) ) ) ) ) ) => ( calc ( bind $?gen263 ( delete-member$ $?gen262 ( create$ rule18-overruled $?gen261 ) ) ) ) ?gen258 <- ( crime_art145 ( negative-overruled $?gen263 ) )"))

([rule18-overruled] of derived-attribute-rule
   (pos-name rule18-overruled-gen2104)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule18] ) ) ) ?gen265 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen264 & : ( >= ?gen264 1 ) ) ) ?gen267 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen266 & : ( >= ?gen266 1 ) ) ) ?gen269 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ( positive ?gen268 & : ( >= ?gen268 1 ) ) ) ?gen271 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen270 & : ( >= ?gen270 1 ) ) ) ?gen273 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen272 & : ( >= ?gen272 1 ) ) ) ?gen258 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen261 ) ( negative-overruled $?gen262 & : ( not ( subseq-pos ( create$ rule18-overruled $?gen261 $$$ $?gen262 ) ) ) ) ( positive-defeated $?gen260 & : ( not ( member$ rule18 $?gen260 ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art145 ) ) => ( calc ( bind $?gen263 ( create$ rule18-overruled $?gen261 $?gen262 ) ) ) ?gen258 <- ( crime_art145 ( negative-overruled $?gen263 ) )"))

([rule18-support] of derived-attribute-rule
   (pos-name rule18-support-gen2106)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule18] ) ) ) ?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen254 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ?gen256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen258 <- ( crime_art145 ( defendant ?Defendant ) ( positive-support $?gen260 & : ( not ( subseq-pos ( create$ rule18 ?gen253 ?gen254 ?gen255 ?gen256 ?gen257 $$$ $?gen260 ) ) ) ) ) ( test ( eq ( class ?gen258 ) crime_art145 ) ) => ( calc ( bind $?gen263 ( create$ rule18 ?gen253 ?gen254 ?gen255 ?gen256 ?gen257 $?gen260 ) ) ) ?gen258 <- ( crime_art145 ( positive-support $?gen263 ) )"))

([rule17-defeasibly-dot] of derived-attribute-rule
   (pos-name rule17-defeasibly-dot-gen2108)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule17] ) ) ) ?gen237 <- ( crime_art145 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule17 $? ) ) ( test ( eq ( class ?gen237 ) crime_art145 ) ) ( not ( and ?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen243 & : ( >= ?gen243 1 ) ) ) ?gen246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen245 & : ( >= ?gen245 1 ) ) ) ?gen248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ( positive ?gen247 & : ( >= ?gen247 1 ) ) ) ?gen250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen249 & : ( >= ?gen249 1 ) ) ) ?gen252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen251 & : ( >= ?gen251 1 ) ) ) ?gen237 <- ( crime_art145 ( negative ~ 2 ) ( positive-overruled $?gen239 & : ( not ( member$ rule17 $?gen239 ) ) ) ) ) ) => ?gen237 <- ( crime_art145 ( positive 0 ) )"))

([rule17-defeasibly] of derived-attribute-rule
   (pos-name rule17-defeasibly-gen2110)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule17] ) ) ) ?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen243 & : ( >= ?gen243 1 ) ) ) ?gen246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen245 & : ( >= ?gen245 1 ) ) ) ?gen248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ( positive ?gen247 & : ( >= ?gen247 1 ) ) ) ?gen250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen249 & : ( >= ?gen249 1 ) ) ) ?gen252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen251 & : ( >= ?gen251 1 ) ) ) ?gen237 <- ( crime_art145 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen239 & : ( not ( member$ rule17 $?gen239 ) ) ) ) ( test ( eq ( class ?gen237 ) crime_art145 ) ) => ?gen237 <- ( crime_art145 ( positive 1 ) ( positive-derivator rule17 ?gen244 ?gen246 ?gen248 ?gen250 ?gen252 ) )"))

([rule17-overruled-dot] of derived-attribute-rule
   (pos-name rule17-overruled-dot-gen2112)
   (depends-on declare crime_art145 lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule17] ) ) ) ?gen237 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen240 ) ( negative-overruled $?gen241 & : ( subseq-pos ( create$ rule17-overruled $?gen240 $$$ $?gen241 ) ) ) ) ( test ( eq ( class ?gen237 ) crime_art145 ) ) ( not ( and ?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen243 & : ( >= ?gen243 1 ) ) ) ?gen246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen245 & : ( >= ?gen245 1 ) ) ) ?gen248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ( positive ?gen247 & : ( >= ?gen247 1 ) ) ) ?gen250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen249 & : ( >= ?gen249 1 ) ) ) ?gen252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen251 & : ( >= ?gen251 1 ) ) ) ?gen237 <- ( crime_art145 ( positive-defeated $?gen239 & : ( not ( member$ rule17 $?gen239 ) ) ) ) ) ) => ( calc ( bind $?gen242 ( delete-member$ $?gen241 ( create$ rule17-overruled $?gen240 ) ) ) ) ?gen237 <- ( crime_art145 ( negative-overruled $?gen242 ) )"))

([rule17-overruled] of derived-attribute-rule
   (pos-name rule17-overruled-gen2114)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule17] ) ) ) ?gen244 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen243 & : ( >= ?gen243 1 ) ) ) ?gen246 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( positive ?gen245 & : ( >= ?gen245 1 ) ) ) ?gen248 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ( positive ?gen247 & : ( >= ?gen247 1 ) ) ) ?gen250 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ( positive ?gen249 & : ( >= ?gen249 1 ) ) ) ?gen252 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ( positive ?gen251 & : ( >= ?gen251 1 ) ) ) ?gen237 <- ( crime_art145 ( defendant ?Defendant ) ( negative-support $?gen240 ) ( negative-overruled $?gen241 & : ( not ( subseq-pos ( create$ rule17-overruled $?gen240 $$$ $?gen241 ) ) ) ) ( positive-defeated $?gen239 & : ( not ( member$ rule17 $?gen239 ) ) ) ) ( test ( eq ( class ?gen237 ) crime_art145 ) ) => ( calc ( bind $?gen242 ( create$ rule17-overruled $?gen240 $?gen241 ) ) ) ?gen237 <- ( crime_art145 ( negative-overruled $?gen242 ) )"))

([rule17-support] of derived-attribute-rule
   (pos-name rule17-support-gen2116)
   (depends-on declare lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule17] ) ) ) ?gen232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen234 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ?gen235 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen236 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen237 <- ( crime_art145 ( defendant ?Defendant ) ( positive-support $?gen239 & : ( not ( subseq-pos ( create$ rule17 ?gen232 ?gen233 ?gen234 ?gen235 ?gen236 $$$ $?gen239 ) ) ) ) ) ( test ( eq ( class ?gen237 ) crime_art145 ) ) => ( calc ( bind $?gen242 ( create$ rule17 ?gen232 ?gen233 ?gen234 ?gen235 ?gen236 $?gen239 ) ) ) ?gen237 <- ( crime_art145 ( positive-support $?gen242 ) )"))

([rule16-defeasibly-dot] of derived-attribute-rule
   (pos-name rule16-defeasibly-dot-gen2118)
   (depends-on declare crime_art144_8 lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule16] ) ) ) ?gen214 <- ( crime_art144_8 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule16 $? ) ) ( test ( eq ( class ?gen214 ) crime_art144_8 ) ) ( not ( and ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen220 & : ( >= ?gen220 1 ) ) ) ?gen223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen222 & : ( >= ?gen222 1 ) ) ) ?gen225 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( positive ?gen224 & : ( >= ?gen224 1 ) ) ) ?gen227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( negative ?gen226 & : ( >= ?gen226 1 ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( negative ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( negative ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen214 <- ( crime_art144_8 ( negative ~ 2 ) ( positive-overruled $?gen216 & : ( not ( member$ rule16 $?gen216 ) ) ) ) ) ) => ?gen214 <- ( crime_art144_8 ( positive 0 ) )"))

([rule16-defeasibly] of derived-attribute-rule
   (pos-name rule16-defeasibly-gen2120)
   (depends-on declare lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule16] ) ) ) ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen220 & : ( >= ?gen220 1 ) ) ) ?gen223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen222 & : ( >= ?gen222 1 ) ) ) ?gen225 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( positive ?gen224 & : ( >= ?gen224 1 ) ) ) ?gen227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( negative ?gen226 & : ( >= ?gen226 1 ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( negative ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( negative ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen214 <- ( crime_art144_8 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen216 & : ( not ( member$ rule16 $?gen216 ) ) ) ) ( test ( eq ( class ?gen214 ) crime_art144_8 ) ) => ?gen214 <- ( crime_art144_8 ( positive 1 ) ( positive-derivator rule16 ?gen221 ?gen223 ?gen225 ?gen227 ?gen229 ?gen231 ) )"))

([rule16-overruled-dot] of derived-attribute-rule
   (pos-name rule16-overruled-dot-gen2122)
   (depends-on declare crime_art144_8 lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule16] ) ) ) ?gen214 <- ( crime_art144_8 ( defendant ?Defendant ) ( negative-support $?gen217 ) ( negative-overruled $?gen218 & : ( subseq-pos ( create$ rule16-overruled $?gen217 $$$ $?gen218 ) ) ) ) ( test ( eq ( class ?gen214 ) crime_art144_8 ) ) ( not ( and ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen220 & : ( >= ?gen220 1 ) ) ) ?gen223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen222 & : ( >= ?gen222 1 ) ) ) ?gen225 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( positive ?gen224 & : ( >= ?gen224 1 ) ) ) ?gen227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( negative ?gen226 & : ( >= ?gen226 1 ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( negative ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( negative ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen214 <- ( crime_art144_8 ( positive-defeated $?gen216 & : ( not ( member$ rule16 $?gen216 ) ) ) ) ) ) => ( calc ( bind $?gen219 ( delete-member$ $?gen218 ( create$ rule16-overruled $?gen217 ) ) ) ) ?gen214 <- ( crime_art144_8 ( negative-overruled $?gen219 ) )"))

([rule16-overruled] of derived-attribute-rule
   (pos-name rule16-overruled-gen2124)
   (depends-on declare lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule16] ) ) ) ?gen221 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen220 & : ( >= ?gen220 1 ) ) ) ?gen223 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ( positive ?gen222 & : ( >= ?gen222 1 ) ) ) ?gen225 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( positive ?gen224 & : ( >= ?gen224 1 ) ) ) ?gen227 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ( negative ?gen226 & : ( >= ?gen226 1 ) ) ) ?gen229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ( negative ?gen228 & : ( >= ?gen228 1 ) ) ) ?gen231 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( negative ?gen230 & : ( >= ?gen230 1 ) ) ) ?gen214 <- ( crime_art144_8 ( defendant ?Defendant ) ( negative-support $?gen217 ) ( negative-overruled $?gen218 & : ( not ( subseq-pos ( create$ rule16-overruled $?gen217 $$$ $?gen218 ) ) ) ) ( positive-defeated $?gen216 & : ( not ( member$ rule16 $?gen216 ) ) ) ) ( test ( eq ( class ?gen214 ) crime_art144_8 ) ) => ( calc ( bind $?gen219 ( create$ rule16-overruled $?gen217 $?gen218 ) ) ) ?gen214 <- ( crime_art144_8 ( negative-overruled $?gen219 ) )"))

([rule16-support] of derived-attribute-rule
   (pos-name rule16-support-gen2126)
   (depends-on declare lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule16] ) ) ) ?gen208 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ?gen210 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ) ?gen211 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen212 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ?gen213 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ) ?gen214 <- ( crime_art144_8 ( defendant ?Defendant ) ( positive-support $?gen216 & : ( not ( subseq-pos ( create$ rule16 ?gen208 ?gen209 ?gen210 ?gen211 ?gen212 ?gen213 $$$ $?gen216 ) ) ) ) ) ( test ( eq ( class ?gen214 ) crime_art144_8 ) ) => ( calc ( bind $?gen219 ( create$ rule16 ?gen208 ?gen209 ?gen210 ?gen211 ?gen212 ?gen213 $?gen216 ) ) ) ?gen214 <- ( crime_art144_8 ( positive-support $?gen219 ) )"))

([rule15-defeasibly-dot] of derived-attribute-rule
   (pos-name rule15-defeasibly-dot-gen2128)
   (depends-on declare crime_art144_7 lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule15] ) ) ) ?gen196 <- ( crime_art144_7 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule15 $? ) ) ( test ( eq ( class ?gen196 ) crime_art144_7 ) ) ( not ( and ?gen203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen202 & : ( >= ?gen202 1 ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen196 <- ( crime_art144_7 ( negative ~ 2 ) ( positive-overruled $?gen198 & : ( not ( member$ rule15 $?gen198 ) ) ) ) ) ) => ?gen196 <- ( crime_art144_7 ( positive 0 ) )"))

([rule15-defeasibly] of derived-attribute-rule
   (pos-name rule15-defeasibly-gen2130)
   (depends-on declare lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule15] ) ) ) ?gen203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen202 & : ( >= ?gen202 1 ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen196 <- ( crime_art144_7 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen198 & : ( not ( member$ rule15 $?gen198 ) ) ) ) ( test ( eq ( class ?gen196 ) crime_art144_7 ) ) => ?gen196 <- ( crime_art144_7 ( positive 1 ) ( positive-derivator rule15 ?gen203 ?gen205 ?gen207 ) )"))

([rule15-overruled-dot] of derived-attribute-rule
   (pos-name rule15-overruled-dot-gen2132)
   (depends-on declare crime_art144_7 lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule15] ) ) ) ?gen196 <- ( crime_art144_7 ( defendant ?Defendant ) ( negative-support $?gen199 ) ( negative-overruled $?gen200 & : ( subseq-pos ( create$ rule15-overruled $?gen199 $$$ $?gen200 ) ) ) ) ( test ( eq ( class ?gen196 ) crime_art144_7 ) ) ( not ( and ?gen203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen202 & : ( >= ?gen202 1 ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen196 <- ( crime_art144_7 ( positive-defeated $?gen198 & : ( not ( member$ rule15 $?gen198 ) ) ) ) ) ) => ( calc ( bind $?gen201 ( delete-member$ $?gen200 ( create$ rule15-overruled $?gen199 ) ) ) ) ?gen196 <- ( crime_art144_7 ( negative-overruled $?gen201 ) )"))

([rule15-overruled] of derived-attribute-rule
   (pos-name rule15-overruled-gen2134)
   (depends-on declare lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule15] ) ) ) ?gen203 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen202 & : ( >= ?gen202 1 ) ) ) ?gen205 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ( positive ?gen204 & : ( >= ?gen204 1 ) ) ) ?gen207 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ( positive ?gen206 & : ( >= ?gen206 1 ) ) ) ?gen196 <- ( crime_art144_7 ( defendant ?Defendant ) ( negative-support $?gen199 ) ( negative-overruled $?gen200 & : ( not ( subseq-pos ( create$ rule15-overruled $?gen199 $$$ $?gen200 ) ) ) ) ( positive-defeated $?gen198 & : ( not ( member$ rule15 $?gen198 ) ) ) ) ( test ( eq ( class ?gen196 ) crime_art144_7 ) ) => ( calc ( bind $?gen201 ( create$ rule15-overruled $?gen199 $?gen200 ) ) ) ?gen196 <- ( crime_art144_7 ( negative-overruled $?gen201 ) )"))

([rule15-support] of derived-attribute-rule
   (pos-name rule15-support-gen2136)
   (depends-on declare lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule15] ) ) ) ?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen194 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ) ?gen196 <- ( crime_art144_7 ( defendant ?Defendant ) ( positive-support $?gen198 & : ( not ( subseq-pos ( create$ rule15 ?gen193 ?gen194 ?gen195 $$$ $?gen198 ) ) ) ) ) ( test ( eq ( class ?gen196 ) crime_art144_7 ) ) => ( calc ( bind $?gen201 ( create$ rule15 ?gen193 ?gen194 ?gen195 $?gen198 ) ) ) ?gen196 <- ( crime_art144_7 ( positive-support $?gen201 ) )"))

([rule14-defeasibly-dot] of derived-attribute-rule
   (pos-name rule14-defeasibly-dot-gen2138)
   (depends-on declare crime_art144_6 lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule14] ) ) ) ?gen183 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule14 $? ) ) ( test ( eq ( class ?gen183 ) crime_art144_6 ) ) ( not ( and ?gen190 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen189 & : ( >= ?gen189 1 ) ) ) ?gen192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen191 & : ( >= ?gen191 1 ) ) ) ?gen183 <- ( crime_art144_6 ( negative ~ 2 ) ( positive-overruled $?gen185 & : ( not ( member$ rule14 $?gen185 ) ) ) ) ) ) => ?gen183 <- ( crime_art144_6 ( positive 0 ) )"))

([rule14-defeasibly] of derived-attribute-rule
   (pos-name rule14-defeasibly-gen2140)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule14] ) ) ) ?gen190 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen189 & : ( >= ?gen189 1 ) ) ) ?gen192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen191 & : ( >= ?gen191 1 ) ) ) ?gen183 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen185 & : ( not ( member$ rule14 $?gen185 ) ) ) ) ( test ( eq ( class ?gen183 ) crime_art144_6 ) ) => ?gen183 <- ( crime_art144_6 ( positive 1 ) ( positive-derivator rule14 ?gen190 ?gen192 ) )"))

([rule14-overruled-dot] of derived-attribute-rule
   (pos-name rule14-overruled-dot-gen2142)
   (depends-on declare crime_art144_6 lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule14] ) ) ) ?gen183 <- ( crime_art144_6 ( defendant ?Defendant ) ( negative-support $?gen186 ) ( negative-overruled $?gen187 & : ( subseq-pos ( create$ rule14-overruled $?gen186 $$$ $?gen187 ) ) ) ) ( test ( eq ( class ?gen183 ) crime_art144_6 ) ) ( not ( and ?gen190 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen189 & : ( >= ?gen189 1 ) ) ) ?gen192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen191 & : ( >= ?gen191 1 ) ) ) ?gen183 <- ( crime_art144_6 ( positive-defeated $?gen185 & : ( not ( member$ rule14 $?gen185 ) ) ) ) ) ) => ( calc ( bind $?gen188 ( delete-member$ $?gen187 ( create$ rule14-overruled $?gen186 ) ) ) ) ?gen183 <- ( crime_art144_6 ( negative-overruled $?gen188 ) )"))

([rule14-overruled] of derived-attribute-rule
   (pos-name rule14-overruled-gen2144)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule14] ) ) ) ?gen190 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen189 & : ( >= ?gen189 1 ) ) ) ?gen192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ( positive ?gen191 & : ( >= ?gen191 1 ) ) ) ?gen183 <- ( crime_art144_6 ( defendant ?Defendant ) ( negative-support $?gen186 ) ( negative-overruled $?gen187 & : ( not ( subseq-pos ( create$ rule14-overruled $?gen186 $$$ $?gen187 ) ) ) ) ( positive-defeated $?gen185 & : ( not ( member$ rule14 $?gen185 ) ) ) ) ( test ( eq ( class ?gen183 ) crime_art144_6 ) ) => ( calc ( bind $?gen188 ( create$ rule14-overruled $?gen186 $?gen187 ) ) ) ?gen183 <- ( crime_art144_6 ( negative-overruled $?gen188 ) )"))

([rule14-support] of derived-attribute-rule
   (pos-name rule14-support-gen2146)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule14] ) ) ) ?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen182 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ?gen183 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive-support $?gen185 & : ( not ( subseq-pos ( create$ rule14 ?gen181 ?gen182 $$$ $?gen185 ) ) ) ) ) ( test ( eq ( class ?gen183 ) crime_art144_6 ) ) => ( calc ( bind $?gen188 ( create$ rule14 ?gen181 ?gen182 $?gen185 ) ) ) ?gen183 <- ( crime_art144_6 ( positive-support $?gen188 ) )"))

([rule13-defeasibly-dot] of derived-attribute-rule
   (pos-name rule13-defeasibly-dot-gen2148)
   (depends-on declare crime_art144_6 lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule13] ) ) ) ?gen171 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule13 $? ) ) ( test ( eq ( class ?gen171 ) crime_art144_6 ) ) ( not ( and ?gen178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen177 & : ( >= ?gen177 1 ) ) ) ?gen180 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen179 & : ( >= ?gen179 1 ) ) ) ?gen171 <- ( crime_art144_6 ( negative ~ 2 ) ( positive-overruled $?gen173 & : ( not ( member$ rule13 $?gen173 ) ) ) ) ) ) => ?gen171 <- ( crime_art144_6 ( positive 0 ) )"))

([rule13-defeasibly] of derived-attribute-rule
   (pos-name rule13-defeasibly-gen2150)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule13] ) ) ) ?gen178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen177 & : ( >= ?gen177 1 ) ) ) ?gen180 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen179 & : ( >= ?gen179 1 ) ) ) ?gen171 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen173 & : ( not ( member$ rule13 $?gen173 ) ) ) ) ( test ( eq ( class ?gen171 ) crime_art144_6 ) ) => ?gen171 <- ( crime_art144_6 ( positive 1 ) ( positive-derivator rule13 ?gen178 ?gen180 ) )"))

([rule13-overruled-dot] of derived-attribute-rule
   (pos-name rule13-overruled-dot-gen2152)
   (depends-on declare crime_art144_6 lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule13] ) ) ) ?gen171 <- ( crime_art144_6 ( defendant ?Defendant ) ( negative-support $?gen174 ) ( negative-overruled $?gen175 & : ( subseq-pos ( create$ rule13-overruled $?gen174 $$$ $?gen175 ) ) ) ) ( test ( eq ( class ?gen171 ) crime_art144_6 ) ) ( not ( and ?gen178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen177 & : ( >= ?gen177 1 ) ) ) ?gen180 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen179 & : ( >= ?gen179 1 ) ) ) ?gen171 <- ( crime_art144_6 ( positive-defeated $?gen173 & : ( not ( member$ rule13 $?gen173 ) ) ) ) ) ) => ( calc ( bind $?gen176 ( delete-member$ $?gen175 ( create$ rule13-overruled $?gen174 ) ) ) ) ?gen171 <- ( crime_art144_6 ( negative-overruled $?gen176 ) )"))

([rule13-overruled] of derived-attribute-rule
   (pos-name rule13-overruled-gen2154)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule13] ) ) ) ?gen178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen177 & : ( >= ?gen177 1 ) ) ) ?gen180 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ( positive ?gen179 & : ( >= ?gen179 1 ) ) ) ?gen171 <- ( crime_art144_6 ( defendant ?Defendant ) ( negative-support $?gen174 ) ( negative-overruled $?gen175 & : ( not ( subseq-pos ( create$ rule13-overruled $?gen174 $$$ $?gen175 ) ) ) ) ( positive-defeated $?gen173 & : ( not ( member$ rule13 $?gen173 ) ) ) ) ( test ( eq ( class ?gen171 ) crime_art144_6 ) ) => ( calc ( bind $?gen176 ( create$ rule13-overruled $?gen174 $?gen175 ) ) ) ?gen171 <- ( crime_art144_6 ( negative-overruled $?gen176 ) )"))

([rule13-support] of derived-attribute-rule
   (pos-name rule13-support-gen2156)
   (depends-on declare lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule13] ) ) ) ?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen170 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen171 <- ( crime_art144_6 ( defendant ?Defendant ) ( positive-support $?gen173 & : ( not ( subseq-pos ( create$ rule13 ?gen169 ?gen170 $$$ $?gen173 ) ) ) ) ) ( test ( eq ( class ?gen171 ) crime_art144_6 ) ) => ( calc ( bind $?gen176 ( create$ rule13 ?gen169 ?gen170 $?gen173 ) ) ) ?gen171 <- ( crime_art144_6 ( positive-support $?gen176 ) )"))

([rule12-defeasibly-dot] of derived-attribute-rule
   (pos-name rule12-defeasibly-dot-gen2158)
   (depends-on declare crime_art144_5 lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule12] ) ) ) ?gen157 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule12 $? ) ) ( test ( eq ( class ?gen157 ) crime_art144_5 ) ) ( not ( and ?gen164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen163 & : ( >= ?gen163 1 ) ) ) ?gen166 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ( positive ?gen165 & : ( >= ?gen165 1 ) ) ) ?gen168 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen167 & : ( >= ?gen167 1 ) ) ) ?gen157 <- ( crime_art144_5 ( negative ~ 2 ) ( positive-overruled $?gen159 & : ( not ( member$ rule12 $?gen159 ) ) ) ) ) ) => ?gen157 <- ( crime_art144_5 ( positive 0 ) )"))

([rule12-defeasibly] of derived-attribute-rule
   (pos-name rule12-defeasibly-gen2160)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule12] ) ) ) ?gen164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen163 & : ( >= ?gen163 1 ) ) ) ?gen166 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ( positive ?gen165 & : ( >= ?gen165 1 ) ) ) ?gen168 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen167 & : ( >= ?gen167 1 ) ) ) ?gen157 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen159 & : ( not ( member$ rule12 $?gen159 ) ) ) ) ( test ( eq ( class ?gen157 ) crime_art144_5 ) ) => ?gen157 <- ( crime_art144_5 ( positive 1 ) ( positive-derivator rule12 ?gen164 ?gen166 ?gen168 ) )"))

([rule12-overruled-dot] of derived-attribute-rule
   (pos-name rule12-overruled-dot-gen2162)
   (depends-on declare crime_art144_5 lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule12] ) ) ) ?gen157 <- ( crime_art144_5 ( defendant ?Defendant ) ( negative-support $?gen160 ) ( negative-overruled $?gen161 & : ( subseq-pos ( create$ rule12-overruled $?gen160 $$$ $?gen161 ) ) ) ) ( test ( eq ( class ?gen157 ) crime_art144_5 ) ) ( not ( and ?gen164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen163 & : ( >= ?gen163 1 ) ) ) ?gen166 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ( positive ?gen165 & : ( >= ?gen165 1 ) ) ) ?gen168 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen167 & : ( >= ?gen167 1 ) ) ) ?gen157 <- ( crime_art144_5 ( positive-defeated $?gen159 & : ( not ( member$ rule12 $?gen159 ) ) ) ) ) ) => ( calc ( bind $?gen162 ( delete-member$ $?gen161 ( create$ rule12-overruled $?gen160 ) ) ) ) ?gen157 <- ( crime_art144_5 ( negative-overruled $?gen162 ) )"))

([rule12-overruled] of derived-attribute-rule
   (pos-name rule12-overruled-gen2164)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule12] ) ) ) ?gen164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen163 & : ( >= ?gen163 1 ) ) ) ?gen166 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ( positive ?gen165 & : ( >= ?gen165 1 ) ) ) ?gen168 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen167 & : ( >= ?gen167 1 ) ) ) ?gen157 <- ( crime_art144_5 ( defendant ?Defendant ) ( negative-support $?gen160 ) ( negative-overruled $?gen161 & : ( not ( subseq-pos ( create$ rule12-overruled $?gen160 $$$ $?gen161 ) ) ) ) ( positive-defeated $?gen159 & : ( not ( member$ rule12 $?gen159 ) ) ) ) ( test ( eq ( class ?gen157 ) crime_art144_5 ) ) => ( calc ( bind $?gen162 ( create$ rule12-overruled $?gen160 $?gen161 ) ) ) ?gen157 <- ( crime_art144_5 ( negative-overruled $?gen162 ) )"))

([rule12-support] of derived-attribute-rule
   (pos-name rule12-support-gen2166)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule12] ) ) ) ?gen154 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen155 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ) ?gen156 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ?gen157 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive-support $?gen159 & : ( not ( subseq-pos ( create$ rule12 ?gen154 ?gen155 ?gen156 $$$ $?gen159 ) ) ) ) ) ( test ( eq ( class ?gen157 ) crime_art144_5 ) ) => ( calc ( bind $?gen162 ( create$ rule12 ?gen154 ?gen155 ?gen156 $?gen159 ) ) ) ?gen157 <- ( crime_art144_5 ( positive-support $?gen162 ) )"))

([rule11-defeasibly-dot] of derived-attribute-rule
   (pos-name rule11-defeasibly-dot-gen2168)
   (depends-on declare crime_art144_5 lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule11] ) ) ) ?gen142 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule11 $? ) ) ( test ( eq ( class ?gen142 ) crime_art144_5 ) ) ( not ( and ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen148 & : ( >= ?gen148 1 ) ) ) ?gen151 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ( positive ?gen150 & : ( >= ?gen150 1 ) ) ) ?gen153 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen152 & : ( >= ?gen152 1 ) ) ) ?gen142 <- ( crime_art144_5 ( negative ~ 2 ) ( positive-overruled $?gen144 & : ( not ( member$ rule11 $?gen144 ) ) ) ) ) ) => ?gen142 <- ( crime_art144_5 ( positive 0 ) )"))

([rule11-defeasibly] of derived-attribute-rule
   (pos-name rule11-defeasibly-gen2170)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule11] ) ) ) ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen148 & : ( >= ?gen148 1 ) ) ) ?gen151 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ( positive ?gen150 & : ( >= ?gen150 1 ) ) ) ?gen153 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen152 & : ( >= ?gen152 1 ) ) ) ?gen142 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen144 & : ( not ( member$ rule11 $?gen144 ) ) ) ) ( test ( eq ( class ?gen142 ) crime_art144_5 ) ) => ?gen142 <- ( crime_art144_5 ( positive 1 ) ( positive-derivator rule11 ?gen149 ?gen151 ?gen153 ) )"))

([rule11-overruled-dot] of derived-attribute-rule
   (pos-name rule11-overruled-dot-gen2172)
   (depends-on declare crime_art144_5 lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule11] ) ) ) ?gen142 <- ( crime_art144_5 ( defendant ?Defendant ) ( negative-support $?gen145 ) ( negative-overruled $?gen146 & : ( subseq-pos ( create$ rule11-overruled $?gen145 $$$ $?gen146 ) ) ) ) ( test ( eq ( class ?gen142 ) crime_art144_5 ) ) ( not ( and ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen148 & : ( >= ?gen148 1 ) ) ) ?gen151 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ( positive ?gen150 & : ( >= ?gen150 1 ) ) ) ?gen153 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen152 & : ( >= ?gen152 1 ) ) ) ?gen142 <- ( crime_art144_5 ( positive-defeated $?gen144 & : ( not ( member$ rule11 $?gen144 ) ) ) ) ) ) => ( calc ( bind $?gen147 ( delete-member$ $?gen146 ( create$ rule11-overruled $?gen145 ) ) ) ) ?gen142 <- ( crime_art144_5 ( negative-overruled $?gen147 ) )"))

([rule11-overruled] of derived-attribute-rule
   (pos-name rule11-overruled-gen2174)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule11] ) ) ) ?gen149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen148 & : ( >= ?gen148 1 ) ) ) ?gen151 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ( positive ?gen150 & : ( >= ?gen150 1 ) ) ) ?gen153 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ( positive ?gen152 & : ( >= ?gen152 1 ) ) ) ?gen142 <- ( crime_art144_5 ( defendant ?Defendant ) ( negative-support $?gen145 ) ( negative-overruled $?gen146 & : ( not ( subseq-pos ( create$ rule11-overruled $?gen145 $$$ $?gen146 ) ) ) ) ( positive-defeated $?gen144 & : ( not ( member$ rule11 $?gen144 ) ) ) ) ( test ( eq ( class ?gen142 ) crime_art144_5 ) ) => ( calc ( bind $?gen147 ( create$ rule11-overruled $?gen145 $?gen146 ) ) ) ?gen142 <- ( crime_art144_5 ( negative-overruled $?gen147 ) )"))

([rule11-support] of derived-attribute-rule
   (pos-name rule11-support-gen2176)
   (depends-on declare lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule11] ) ) ) ?gen139 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen140 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ) ?gen141 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ?gen142 <- ( crime_art144_5 ( defendant ?Defendant ) ( positive-support $?gen144 & : ( not ( subseq-pos ( create$ rule11 ?gen139 ?gen140 ?gen141 $$$ $?gen144 ) ) ) ) ) ( test ( eq ( class ?gen142 ) crime_art144_5 ) ) => ( calc ( bind $?gen147 ( create$ rule11 ?gen139 ?gen140 ?gen141 $?gen144 ) ) ) ?gen142 <- ( crime_art144_5 ( positive-support $?gen147 ) )"))

([rule10-defeasibly-dot] of derived-attribute-rule
   (pos-name rule10-defeasibly-dot-gen2178)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule10] ) ) ) ?gen129 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule10 $? ) ) ( test ( eq ( class ?gen129 ) crime_art144_4 ) ) ( not ( and ?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen135 & : ( >= ?gen135 1 ) ) ) ?gen138 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ( positive ?gen137 & : ( >= ?gen137 1 ) ) ) ?gen129 <- ( crime_art144_4 ( negative ~ 2 ) ( positive-overruled $?gen131 & : ( not ( member$ rule10 $?gen131 ) ) ) ) ) ) => ?gen129 <- ( crime_art144_4 ( positive 0 ) )"))

([rule10-defeasibly] of derived-attribute-rule
   (pos-name rule10-defeasibly-gen2180)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule10] ) ) ) ?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen135 & : ( >= ?gen135 1 ) ) ) ?gen138 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ( positive ?gen137 & : ( >= ?gen137 1 ) ) ) ?gen129 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen131 & : ( not ( member$ rule10 $?gen131 ) ) ) ) ( test ( eq ( class ?gen129 ) crime_art144_4 ) ) => ?gen129 <- ( crime_art144_4 ( positive 1 ) ( positive-derivator rule10 ?gen136 ?gen138 ) )"))

([rule10-overruled-dot] of derived-attribute-rule
   (pos-name rule10-overruled-dot-gen2182)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule10] ) ) ) ?gen129 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen132 ) ( negative-overruled $?gen133 & : ( subseq-pos ( create$ rule10-overruled $?gen132 $$$ $?gen133 ) ) ) ) ( test ( eq ( class ?gen129 ) crime_art144_4 ) ) ( not ( and ?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen135 & : ( >= ?gen135 1 ) ) ) ?gen138 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ( positive ?gen137 & : ( >= ?gen137 1 ) ) ) ?gen129 <- ( crime_art144_4 ( positive-defeated $?gen131 & : ( not ( member$ rule10 $?gen131 ) ) ) ) ) ) => ( calc ( bind $?gen134 ( delete-member$ $?gen133 ( create$ rule10-overruled $?gen132 ) ) ) ) ?gen129 <- ( crime_art144_4 ( negative-overruled $?gen134 ) )"))

([rule10-overruled] of derived-attribute-rule
   (pos-name rule10-overruled-gen2184)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule10] ) ) ) ?gen136 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen135 & : ( >= ?gen135 1 ) ) ) ?gen138 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ( positive ?gen137 & : ( >= ?gen137 1 ) ) ) ?gen129 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen132 ) ( negative-overruled $?gen133 & : ( not ( subseq-pos ( create$ rule10-overruled $?gen132 $$$ $?gen133 ) ) ) ) ( positive-defeated $?gen131 & : ( not ( member$ rule10 $?gen131 ) ) ) ) ( test ( eq ( class ?gen129 ) crime_art144_4 ) ) => ( calc ( bind $?gen134 ( create$ rule10-overruled $?gen132 $?gen133 ) ) ) ?gen129 <- ( crime_art144_4 ( negative-overruled $?gen134 ) )"))

([rule10-support] of derived-attribute-rule
   (pos-name rule10-support-gen2186)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule10] ) ) ) ?gen127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen128 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ) ?gen129 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive-support $?gen131 & : ( not ( subseq-pos ( create$ rule10 ?gen127 ?gen128 $$$ $?gen131 ) ) ) ) ) ( test ( eq ( class ?gen129 ) crime_art144_4 ) ) => ( calc ( bind $?gen134 ( create$ rule10 ?gen127 ?gen128 $?gen131 ) ) ) ?gen129 <- ( crime_art144_4 ( positive-support $?gen134 ) )"))

([rule9b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule9b-defeasibly-dot-gen2188)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule9b] ) ) ) ?gen117 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule9b $? ) ) ( test ( eq ( class ?gen117 ) crime_art144_4 ) ) ( not ( and ?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen123 & : ( >= ?gen123 1 ) ) ) ?gen126 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ( positive ?gen125 & : ( >= ?gen125 1 ) ) ) ?gen117 <- ( crime_art144_4 ( negative ~ 2 ) ( positive-overruled $?gen119 & : ( not ( member$ rule9b $?gen119 ) ) ) ) ) ) => ?gen117 <- ( crime_art144_4 ( positive 0 ) )"))

([rule9b-defeasibly] of derived-attribute-rule
   (pos-name rule9b-defeasibly-gen2190)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule9b] ) ) ) ?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen123 & : ( >= ?gen123 1 ) ) ) ?gen126 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ( positive ?gen125 & : ( >= ?gen125 1 ) ) ) ?gen117 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen119 & : ( not ( member$ rule9b $?gen119 ) ) ) ) ( test ( eq ( class ?gen117 ) crime_art144_4 ) ) => ?gen117 <- ( crime_art144_4 ( positive 1 ) ( positive-derivator rule9b ?gen124 ?gen126 ) )"))

([rule9b-overruled-dot] of derived-attribute-rule
   (pos-name rule9b-overruled-dot-gen2192)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule9b] ) ) ) ?gen117 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen120 ) ( negative-overruled $?gen121 & : ( subseq-pos ( create$ rule9b-overruled $?gen120 $$$ $?gen121 ) ) ) ) ( test ( eq ( class ?gen117 ) crime_art144_4 ) ) ( not ( and ?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen123 & : ( >= ?gen123 1 ) ) ) ?gen126 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ( positive ?gen125 & : ( >= ?gen125 1 ) ) ) ?gen117 <- ( crime_art144_4 ( positive-defeated $?gen119 & : ( not ( member$ rule9b $?gen119 ) ) ) ) ) ) => ( calc ( bind $?gen122 ( delete-member$ $?gen121 ( create$ rule9b-overruled $?gen120 ) ) ) ) ?gen117 <- ( crime_art144_4 ( negative-overruled $?gen122 ) )"))

([rule9b-overruled] of derived-attribute-rule
   (pos-name rule9b-overruled-gen2194)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule9b] ) ) ) ?gen124 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen123 & : ( >= ?gen123 1 ) ) ) ?gen126 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ( positive ?gen125 & : ( >= ?gen125 1 ) ) ) ?gen117 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen120 ) ( negative-overruled $?gen121 & : ( not ( subseq-pos ( create$ rule9b-overruled $?gen120 $$$ $?gen121 ) ) ) ) ( positive-defeated $?gen119 & : ( not ( member$ rule9b $?gen119 ) ) ) ) ( test ( eq ( class ?gen117 ) crime_art144_4 ) ) => ( calc ( bind $?gen122 ( create$ rule9b-overruled $?gen120 $?gen121 ) ) ) ?gen117 <- ( crime_art144_4 ( negative-overruled $?gen122 ) )"))

([rule9b-support] of derived-attribute-rule
   (pos-name rule9b-support-gen2196)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule9b] ) ) ) ?gen115 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ) ?gen117 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive-support $?gen119 & : ( not ( subseq-pos ( create$ rule9b ?gen115 ?gen116 $$$ $?gen119 ) ) ) ) ) ( test ( eq ( class ?gen117 ) crime_art144_4 ) ) => ( calc ( bind $?gen122 ( create$ rule9b ?gen115 ?gen116 $?gen119 ) ) ) ?gen117 <- ( crime_art144_4 ( positive-support $?gen122 ) )"))

([rule9-defeasibly-dot] of derived-attribute-rule
   (pos-name rule9-defeasibly-dot-gen2198)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule9] ) ) ) ?gen105 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule9 $? ) ) ( test ( eq ( class ?gen105 ) crime_art144_4 ) ) ( not ( and ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art144_4 ( negative ~ 2 ) ( positive-overruled $?gen107 & : ( not ( member$ rule9 $?gen107 ) ) ) ) ) ) => ?gen105 <- ( crime_art144_4 ( positive 0 ) )"))

([rule9-defeasibly] of derived-attribute-rule
   (pos-name rule9-defeasibly-gen2200)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule9] ) ) ) ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen107 & : ( not ( member$ rule9 $?gen107 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art144_4 ) ) => ?gen105 <- ( crime_art144_4 ( positive 1 ) ( positive-derivator rule9 ?gen112 ?gen114 ) )"))

([rule9-overruled-dot] of derived-attribute-rule
   (pos-name rule9-overruled-dot-gen2202)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule9] ) ) ) ?gen105 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen108 ) ( negative-overruled $?gen109 & : ( subseq-pos ( create$ rule9-overruled $?gen108 $$$ $?gen109 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art144_4 ) ) ( not ( and ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art144_4 ( positive-defeated $?gen107 & : ( not ( member$ rule9 $?gen107 ) ) ) ) ) ) => ( calc ( bind $?gen110 ( delete-member$ $?gen109 ( create$ rule9-overruled $?gen108 ) ) ) ) ?gen105 <- ( crime_art144_4 ( negative-overruled $?gen110 ) )"))

([rule9-overruled] of derived-attribute-rule
   (pos-name rule9-overruled-gen2204)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule9] ) ) ) ?gen112 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen111 & : ( >= ?gen111 1 ) ) ) ?gen114 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ( positive ?gen113 & : ( >= ?gen113 1 ) ) ) ?gen105 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen108 ) ( negative-overruled $?gen109 & : ( not ( subseq-pos ( create$ rule9-overruled $?gen108 $$$ $?gen109 ) ) ) ) ( positive-defeated $?gen107 & : ( not ( member$ rule9 $?gen107 ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art144_4 ) ) => ( calc ( bind $?gen110 ( create$ rule9-overruled $?gen108 $?gen109 ) ) ) ?gen105 <- ( crime_art144_4 ( negative-overruled $?gen110 ) )"))

([rule9-support] of derived-attribute-rule
   (pos-name rule9-support-gen2206)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule9] ) ) ) ?gen103 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ) ?gen105 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive-support $?gen107 & : ( not ( subseq-pos ( create$ rule9 ?gen103 ?gen104 $$$ $?gen107 ) ) ) ) ) ( test ( eq ( class ?gen105 ) crime_art144_4 ) ) => ( calc ( bind $?gen110 ( create$ rule9 ?gen103 ?gen104 $?gen107 ) ) ) ?gen105 <- ( crime_art144_4 ( positive-support $?gen110 ) )"))

([rule8-defeasibly-dot] of derived-attribute-rule
   (pos-name rule8-defeasibly-dot-gen2208)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule8] ) ) ) ?gen93 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule8 $? ) ) ( test ( eq ( class ?gen93 ) crime_art144_4 ) ) ( not ( and ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art144_4 ( negative ~ 2 ) ( positive-overruled $?gen95 & : ( not ( member$ rule8 $?gen95 ) ) ) ) ) ) => ?gen93 <- ( crime_art144_4 ( positive 0 ) )"))

([rule8-defeasibly] of derived-attribute-rule
   (pos-name rule8-defeasibly-gen2210)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule8] ) ) ) ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen95 & : ( not ( member$ rule8 $?gen95 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art144_4 ) ) => ?gen93 <- ( crime_art144_4 ( positive 1 ) ( positive-derivator rule8 ?gen100 ?gen102 ) )"))

([rule8-overruled-dot] of derived-attribute-rule
   (pos-name rule8-overruled-dot-gen2212)
   (depends-on declare crime_art144_4 lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule8] ) ) ) ?gen93 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen96 ) ( negative-overruled $?gen97 & : ( subseq-pos ( create$ rule8-overruled $?gen96 $$$ $?gen97 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art144_4 ) ) ( not ( and ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art144_4 ( positive-defeated $?gen95 & : ( not ( member$ rule8 $?gen95 ) ) ) ) ) ) => ( calc ( bind $?gen98 ( delete-member$ $?gen97 ( create$ rule8-overruled $?gen96 ) ) ) ) ?gen93 <- ( crime_art144_4 ( negative-overruled $?gen98 ) )"))

([rule8-overruled] of derived-attribute-rule
   (pos-name rule8-overruled-gen2214)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule8] ) ) ) ?gen100 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen99 & : ( >= ?gen99 1 ) ) ) ?gen102 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ( positive ?gen101 & : ( >= ?gen101 1 ) ) ) ?gen93 <- ( crime_art144_4 ( defendant ?Defendant ) ( negative-support $?gen96 ) ( negative-overruled $?gen97 & : ( not ( subseq-pos ( create$ rule8-overruled $?gen96 $$$ $?gen97 ) ) ) ) ( positive-defeated $?gen95 & : ( not ( member$ rule8 $?gen95 ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art144_4 ) ) => ( calc ( bind $?gen98 ( create$ rule8-overruled $?gen96 $?gen97 ) ) ) ?gen93 <- ( crime_art144_4 ( negative-overruled $?gen98 ) )"))

([rule8-support] of derived-attribute-rule
   (pos-name rule8-support-gen2216)
   (depends-on declare lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule8] ) ) ) ?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen92 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ) ?gen93 <- ( crime_art144_4 ( defendant ?Defendant ) ( positive-support $?gen95 & : ( not ( subseq-pos ( create$ rule8 ?gen91 ?gen92 $$$ $?gen95 ) ) ) ) ) ( test ( eq ( class ?gen93 ) crime_art144_4 ) ) => ( calc ( bind $?gen98 ( create$ rule8 ?gen91 ?gen92 $?gen95 ) ) ) ?gen93 <- ( crime_art144_4 ( positive-support $?gen98 ) )"))

([rule7b-defeasibly-dot] of derived-attribute-rule
   (pos-name rule7b-defeasibly-dot-gen2218)
   (depends-on declare crime_art144_3 lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule7b] ) ) ) ?gen79 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule7b $? ) ) ( test ( eq ( class ?gen79 ) crime_art144_3 ) ) ( not ( and ?gen86 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen85 & : ( >= ?gen85 1 ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen79 <- ( crime_art144_3 ( negative ~ 2 ) ( positive-overruled $?gen81 & : ( not ( member$ rule7b $?gen81 ) ) ) ) ) ) => ?gen79 <- ( crime_art144_3 ( positive 0 ) )"))

([rule7b-defeasibly] of derived-attribute-rule
   (pos-name rule7b-defeasibly-gen2220)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule7b] ) ) ) ?gen86 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen85 & : ( >= ?gen85 1 ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen79 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen81 & : ( not ( member$ rule7b $?gen81 ) ) ) ) ( test ( eq ( class ?gen79 ) crime_art144_3 ) ) => ?gen79 <- ( crime_art144_3 ( positive 1 ) ( positive-derivator rule7b ?gen86 ?gen88 ?gen90 ) )"))

([rule7b-overruled-dot] of derived-attribute-rule
   (pos-name rule7b-overruled-dot-gen2222)
   (depends-on declare crime_art144_3 lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule7b] ) ) ) ?gen79 <- ( crime_art144_3 ( defendant ?Defendant ) ( negative-support $?gen82 ) ( negative-overruled $?gen83 & : ( subseq-pos ( create$ rule7b-overruled $?gen82 $$$ $?gen83 ) ) ) ) ( test ( eq ( class ?gen79 ) crime_art144_3 ) ) ( not ( and ?gen86 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen85 & : ( >= ?gen85 1 ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen79 <- ( crime_art144_3 ( positive-defeated $?gen81 & : ( not ( member$ rule7b $?gen81 ) ) ) ) ) ) => ( calc ( bind $?gen84 ( delete-member$ $?gen83 ( create$ rule7b-overruled $?gen82 ) ) ) ) ?gen79 <- ( crime_art144_3 ( negative-overruled $?gen84 ) )"))

([rule7b-overruled] of derived-attribute-rule
   (pos-name rule7b-overruled-gen2224)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule7b] ) ) ) ?gen86 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen85 & : ( >= ?gen85 1 ) ) ) ?gen88 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen87 & : ( >= ?gen87 1 ) ) ) ?gen90 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen89 & : ( >= ?gen89 1 ) ) ) ?gen79 <- ( crime_art144_3 ( defendant ?Defendant ) ( negative-support $?gen82 ) ( negative-overruled $?gen83 & : ( not ( subseq-pos ( create$ rule7b-overruled $?gen82 $$$ $?gen83 ) ) ) ) ( positive-defeated $?gen81 & : ( not ( member$ rule7b $?gen81 ) ) ) ) ( test ( eq ( class ?gen79 ) crime_art144_3 ) ) => ( calc ( bind $?gen84 ( create$ rule7b-overruled $?gen82 $?gen83 ) ) ) ?gen79 <- ( crime_art144_3 ( negative-overruled $?gen84 ) )"))

([rule7b-support] of derived-attribute-rule
   (pos-name rule7b-support-gen2226)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule7b] ) ) ) ?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen77 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ?gen79 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive-support $?gen81 & : ( not ( subseq-pos ( create$ rule7b ?gen76 ?gen77 ?gen78 $$$ $?gen81 ) ) ) ) ) ( test ( eq ( class ?gen79 ) crime_art144_3 ) ) => ( calc ( bind $?gen84 ( create$ rule7b ?gen76 ?gen77 ?gen78 $?gen81 ) ) ) ?gen79 <- ( crime_art144_3 ( positive-support $?gen84 ) )"))

([rule7-defeasibly-dot] of derived-attribute-rule
   (pos-name rule7-defeasibly-dot-gen2228)
   (depends-on declare crime_art144_3 lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule7] ) ) ) ?gen64 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule7 $? ) ) ( test ( eq ( class ?gen64 ) crime_art144_3 ) ) ( not ( and ?gen71 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen70 & : ( >= ?gen70 1 ) ) ) ?gen73 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen72 & : ( >= ?gen72 1 ) ) ) ?gen75 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen74 & : ( >= ?gen74 1 ) ) ) ?gen64 <- ( crime_art144_3 ( negative ~ 2 ) ( positive-overruled $?gen66 & : ( not ( member$ rule7 $?gen66 ) ) ) ) ) ) => ?gen64 <- ( crime_art144_3 ( positive 0 ) )"))

([rule7-defeasibly] of derived-attribute-rule
   (pos-name rule7-defeasibly-gen2230)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule7] ) ) ) ?gen71 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen70 & : ( >= ?gen70 1 ) ) ) ?gen73 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen72 & : ( >= ?gen72 1 ) ) ) ?gen75 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen74 & : ( >= ?gen74 1 ) ) ) ?gen64 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen66 & : ( not ( member$ rule7 $?gen66 ) ) ) ) ( test ( eq ( class ?gen64 ) crime_art144_3 ) ) => ?gen64 <- ( crime_art144_3 ( positive 1 ) ( positive-derivator rule7 ?gen71 ?gen73 ?gen75 ) )"))

([rule7-overruled-dot] of derived-attribute-rule
   (pos-name rule7-overruled-dot-gen2232)
   (depends-on declare crime_art144_3 lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule7] ) ) ) ?gen64 <- ( crime_art144_3 ( defendant ?Defendant ) ( negative-support $?gen67 ) ( negative-overruled $?gen68 & : ( subseq-pos ( create$ rule7-overruled $?gen67 $$$ $?gen68 ) ) ) ) ( test ( eq ( class ?gen64 ) crime_art144_3 ) ) ( not ( and ?gen71 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen70 & : ( >= ?gen70 1 ) ) ) ?gen73 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen72 & : ( >= ?gen72 1 ) ) ) ?gen75 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen74 & : ( >= ?gen74 1 ) ) ) ?gen64 <- ( crime_art144_3 ( positive-defeated $?gen66 & : ( not ( member$ rule7 $?gen66 ) ) ) ) ) ) => ( calc ( bind $?gen69 ( delete-member$ $?gen68 ( create$ rule7-overruled $?gen67 ) ) ) ) ?gen64 <- ( crime_art144_3 ( negative-overruled $?gen69 ) )"))

([rule7-overruled] of derived-attribute-rule
   (pos-name rule7-overruled-gen2234)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule7] ) ) ) ?gen71 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen70 & : ( >= ?gen70 1 ) ) ) ?gen73 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen72 & : ( >= ?gen72 1 ) ) ) ?gen75 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ( positive ?gen74 & : ( >= ?gen74 1 ) ) ) ?gen64 <- ( crime_art144_3 ( defendant ?Defendant ) ( negative-support $?gen67 ) ( negative-overruled $?gen68 & : ( not ( subseq-pos ( create$ rule7-overruled $?gen67 $$$ $?gen68 ) ) ) ) ( positive-defeated $?gen66 & : ( not ( member$ rule7 $?gen66 ) ) ) ) ( test ( eq ( class ?gen64 ) crime_art144_3 ) ) => ( calc ( bind $?gen69 ( create$ rule7-overruled $?gen67 $?gen68 ) ) ) ?gen64 <- ( crime_art144_3 ( negative-overruled $?gen69 ) )"))

([rule7-support] of derived-attribute-rule
   (pos-name rule7-support-gen2236)
   (depends-on declare lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule7] ) ) ) ?gen61 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen62 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ?gen63 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ?gen64 <- ( crime_art144_3 ( defendant ?Defendant ) ( positive-support $?gen66 & : ( not ( subseq-pos ( create$ rule7 ?gen61 ?gen62 ?gen63 $$$ $?gen66 ) ) ) ) ) ( test ( eq ( class ?gen64 ) crime_art144_3 ) ) => ( calc ( bind $?gen69 ( create$ rule7 ?gen61 ?gen62 ?gen63 $?gen66 ) ) ) ?gen64 <- ( crime_art144_3 ( positive-support $?gen69 ) )"))

([rule6-defeasibly-dot] of derived-attribute-rule
   (pos-name rule6-defeasibly-dot-gen2238)
   (depends-on declare crime_art144_2 lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule6] ) ) ) ?gen51 <- ( crime_art144_2 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule6 $? ) ) ( test ( eq ( class ?gen51 ) crime_art144_2 ) ) ( not ( and ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen57 & : ( >= ?gen57 1 ) ) ) ?gen60 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ( positive ?gen59 & : ( >= ?gen59 1 ) ) ) ?gen51 <- ( crime_art144_2 ( negative ~ 2 ) ( positive-overruled $?gen53 & : ( not ( member$ rule6 $?gen53 ) ) ) ) ) ) => ?gen51 <- ( crime_art144_2 ( positive 0 ) )"))

([rule6-defeasibly] of derived-attribute-rule
   (pos-name rule6-defeasibly-gen2240)
   (depends-on declare lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule6] ) ) ) ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen57 & : ( >= ?gen57 1 ) ) ) ?gen60 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ( positive ?gen59 & : ( >= ?gen59 1 ) ) ) ?gen51 <- ( crime_art144_2 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen53 & : ( not ( member$ rule6 $?gen53 ) ) ) ) ( test ( eq ( class ?gen51 ) crime_art144_2 ) ) => ?gen51 <- ( crime_art144_2 ( positive 1 ) ( positive-derivator rule6 ?gen58 ?gen60 ) )"))

([rule6-overruled-dot] of derived-attribute-rule
   (pos-name rule6-overruled-dot-gen2242)
   (depends-on declare crime_art144_2 lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule6] ) ) ) ?gen51 <- ( crime_art144_2 ( defendant ?Defendant ) ( negative-support $?gen54 ) ( negative-overruled $?gen55 & : ( subseq-pos ( create$ rule6-overruled $?gen54 $$$ $?gen55 ) ) ) ) ( test ( eq ( class ?gen51 ) crime_art144_2 ) ) ( not ( and ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen57 & : ( >= ?gen57 1 ) ) ) ?gen60 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ( positive ?gen59 & : ( >= ?gen59 1 ) ) ) ?gen51 <- ( crime_art144_2 ( positive-defeated $?gen53 & : ( not ( member$ rule6 $?gen53 ) ) ) ) ) ) => ( calc ( bind $?gen56 ( delete-member$ $?gen55 ( create$ rule6-overruled $?gen54 ) ) ) ) ?gen51 <- ( crime_art144_2 ( negative-overruled $?gen56 ) )"))

([rule6-overruled] of derived-attribute-rule
   (pos-name rule6-overruled-gen2244)
   (depends-on declare lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule6] ) ) ) ?gen58 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen57 & : ( >= ?gen57 1 ) ) ) ?gen60 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ( positive ?gen59 & : ( >= ?gen59 1 ) ) ) ?gen51 <- ( crime_art144_2 ( defendant ?Defendant ) ( negative-support $?gen54 ) ( negative-overruled $?gen55 & : ( not ( subseq-pos ( create$ rule6-overruled $?gen54 $$$ $?gen55 ) ) ) ) ( positive-defeated $?gen53 & : ( not ( member$ rule6 $?gen53 ) ) ) ) ( test ( eq ( class ?gen51 ) crime_art144_2 ) ) => ( calc ( bind $?gen56 ( create$ rule6-overruled $?gen54 $?gen55 ) ) ) ?gen51 <- ( crime_art144_2 ( negative-overruled $?gen56 ) )"))

([rule6-support] of derived-attribute-rule
   (pos-name rule6-support-gen2246)
   (depends-on declare lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule6] ) ) ) ?gen49 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen50 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ) ?gen51 <- ( crime_art144_2 ( defendant ?Defendant ) ( positive-support $?gen53 & : ( not ( subseq-pos ( create$ rule6 ?gen49 ?gen50 $$$ $?gen53 ) ) ) ) ) ( test ( eq ( class ?gen51 ) crime_art144_2 ) ) => ( calc ( bind $?gen56 ( create$ rule6 ?gen49 ?gen50 $?gen53 ) ) ) ?gen51 <- ( crime_art144_2 ( positive-support $?gen56 ) )"))

([rule5-defeasibly-dot] of derived-attribute-rule
   (pos-name rule5-defeasibly-dot-gen2248)
   (depends-on declare crime_art144_1 lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule5] ) ) ) ?gen39 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule5 $? ) ) ( test ( eq ( class ?gen39 ) crime_art144_1 ) ) ( not ( and ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen45 & : ( >= ?gen45 1 ) ) ) ?gen48 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ( positive ?gen47 & : ( >= ?gen47 1 ) ) ) ?gen39 <- ( crime_art144_1 ( negative ~ 2 ) ( positive-overruled $?gen41 & : ( not ( member$ rule5 $?gen41 ) ) ) ) ) ) => ?gen39 <- ( crime_art144_1 ( positive 0 ) )"))

([rule5-defeasibly] of derived-attribute-rule
   (pos-name rule5-defeasibly-gen2250)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule5] ) ) ) ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen45 & : ( >= ?gen45 1 ) ) ) ?gen48 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ( positive ?gen47 & : ( >= ?gen47 1 ) ) ) ?gen39 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen41 & : ( not ( member$ rule5 $?gen41 ) ) ) ) ( test ( eq ( class ?gen39 ) crime_art144_1 ) ) => ?gen39 <- ( crime_art144_1 ( positive 1 ) ( positive-derivator rule5 ?gen46 ?gen48 ) )"))

([rule5-overruled-dot] of derived-attribute-rule
   (pos-name rule5-overruled-dot-gen2252)
   (depends-on declare crime_art144_1 lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule5] ) ) ) ?gen39 <- ( crime_art144_1 ( defendant ?Defendant ) ( negative-support $?gen42 ) ( negative-overruled $?gen43 & : ( subseq-pos ( create$ rule5-overruled $?gen42 $$$ $?gen43 ) ) ) ) ( test ( eq ( class ?gen39 ) crime_art144_1 ) ) ( not ( and ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen45 & : ( >= ?gen45 1 ) ) ) ?gen48 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ( positive ?gen47 & : ( >= ?gen47 1 ) ) ) ?gen39 <- ( crime_art144_1 ( positive-defeated $?gen41 & : ( not ( member$ rule5 $?gen41 ) ) ) ) ) ) => ( calc ( bind $?gen44 ( delete-member$ $?gen43 ( create$ rule5-overruled $?gen42 ) ) ) ) ?gen39 <- ( crime_art144_1 ( negative-overruled $?gen44 ) )"))

([rule5-overruled] of derived-attribute-rule
   (pos-name rule5-overruled-gen2254)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule5] ) ) ) ?gen46 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen45 & : ( >= ?gen45 1 ) ) ) ?gen48 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ( positive ?gen47 & : ( >= ?gen47 1 ) ) ) ?gen39 <- ( crime_art144_1 ( defendant ?Defendant ) ( negative-support $?gen42 ) ( negative-overruled $?gen43 & : ( not ( subseq-pos ( create$ rule5-overruled $?gen42 $$$ $?gen43 ) ) ) ) ( positive-defeated $?gen41 & : ( not ( member$ rule5 $?gen41 ) ) ) ) ( test ( eq ( class ?gen39 ) crime_art144_1 ) ) => ( calc ( bind $?gen44 ( create$ rule5-overruled $?gen42 $?gen43 ) ) ) ?gen39 <- ( crime_art144_1 ( negative-overruled $?gen44 ) )"))

([rule5-support] of derived-attribute-rule
   (pos-name rule5-support-gen2256)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule5] ) ) ) ?gen37 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen38 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ) ?gen39 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive-support $?gen41 & : ( not ( subseq-pos ( create$ rule5 ?gen37 ?gen38 $$$ $?gen41 ) ) ) ) ) ( test ( eq ( class ?gen39 ) crime_art144_1 ) ) => ( calc ( bind $?gen44 ( create$ rule5 ?gen37 ?gen38 $?gen41 ) ) ) ?gen39 <- ( crime_art144_1 ( positive-support $?gen44 ) )"))

([rule4-defeasibly-dot] of derived-attribute-rule
   (pos-name rule4-defeasibly-dot-gen2258)
   (depends-on declare crime_art144_1 lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule4] ) ) ) ?gen27 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule4 $? ) ) ( test ( eq ( class ?gen27 ) crime_art144_1 ) ) ( not ( and ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen33 & : ( >= ?gen33 1 ) ) ) ?gen36 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ( positive ?gen35 & : ( >= ?gen35 1 ) ) ) ?gen27 <- ( crime_art144_1 ( negative ~ 2 ) ( positive-overruled $?gen29 & : ( not ( member$ rule4 $?gen29 ) ) ) ) ) ) => ?gen27 <- ( crime_art144_1 ( positive 0 ) )"))

([rule4-defeasibly] of derived-attribute-rule
   (pos-name rule4-defeasibly-gen2260)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule4] ) ) ) ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen33 & : ( >= ?gen33 1 ) ) ) ?gen36 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ( positive ?gen35 & : ( >= ?gen35 1 ) ) ) ?gen27 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen29 & : ( not ( member$ rule4 $?gen29 ) ) ) ) ( test ( eq ( class ?gen27 ) crime_art144_1 ) ) => ?gen27 <- ( crime_art144_1 ( positive 1 ) ( positive-derivator rule4 ?gen34 ?gen36 ) )"))

([rule4-overruled-dot] of derived-attribute-rule
   (pos-name rule4-overruled-dot-gen2262)
   (depends-on declare crime_art144_1 lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule4] ) ) ) ?gen27 <- ( crime_art144_1 ( defendant ?Defendant ) ( negative-support $?gen30 ) ( negative-overruled $?gen31 & : ( subseq-pos ( create$ rule4-overruled $?gen30 $$$ $?gen31 ) ) ) ) ( test ( eq ( class ?gen27 ) crime_art144_1 ) ) ( not ( and ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen33 & : ( >= ?gen33 1 ) ) ) ?gen36 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ( positive ?gen35 & : ( >= ?gen35 1 ) ) ) ?gen27 <- ( crime_art144_1 ( positive-defeated $?gen29 & : ( not ( member$ rule4 $?gen29 ) ) ) ) ) ) => ( calc ( bind $?gen32 ( delete-member$ $?gen31 ( create$ rule4-overruled $?gen30 ) ) ) ) ?gen27 <- ( crime_art144_1 ( negative-overruled $?gen32 ) )"))

([rule4-overruled] of derived-attribute-rule
   (pos-name rule4-overruled-gen2264)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule4] ) ) ) ?gen34 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen33 & : ( >= ?gen33 1 ) ) ) ?gen36 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ( positive ?gen35 & : ( >= ?gen35 1 ) ) ) ?gen27 <- ( crime_art144_1 ( defendant ?Defendant ) ( negative-support $?gen30 ) ( negative-overruled $?gen31 & : ( not ( subseq-pos ( create$ rule4-overruled $?gen30 $$$ $?gen31 ) ) ) ) ( positive-defeated $?gen29 & : ( not ( member$ rule4 $?gen29 ) ) ) ) ( test ( eq ( class ?gen27 ) crime_art144_1 ) ) => ( calc ( bind $?gen32 ( create$ rule4-overruled $?gen30 $?gen31 ) ) ) ?gen27 <- ( crime_art144_1 ( negative-overruled $?gen32 ) )"))

([rule4-support] of derived-attribute-rule
   (pos-name rule4-support-gen2266)
   (depends-on declare lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule4] ) ) ) ?gen25 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen26 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ) ?gen27 <- ( crime_art144_1 ( defendant ?Defendant ) ( positive-support $?gen29 & : ( not ( subseq-pos ( create$ rule4 ?gen25 ?gen26 $$$ $?gen29 ) ) ) ) ) ( test ( eq ( class ?gen27 ) crime_art144_1 ) ) => ( calc ( bind $?gen32 ( create$ rule4 ?gen25 ?gen26 $?gen29 ) ) ) ?gen27 <- ( crime_art144_1 ( positive-support $?gen32 ) )"))

([rule2-defeasibly-dot] of derived-attribute-rule
   (pos-name rule2-defeasibly-dot-gen2268)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule2] ) ) ) ?gen15 <- ( crime_art143 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule2 $? ) ) ( test ( eq ( class ?gen15 ) crime_art143 ) ) ( not ( and ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen21 & : ( >= ?gen21 1 ) ) ) ?gen24 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen23 & : ( >= ?gen23 1 ) ) ) ?gen15 <- ( crime_art143 ( negative ~ 2 ) ( positive-overruled $?gen17 & : ( not ( member$ rule2 $?gen17 ) ) ) ) ) ) => ?gen15 <- ( crime_art143 ( positive 0 ) )"))

([rule2-defeasibly] of derived-attribute-rule
   (pos-name rule2-defeasibly-gen2270)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule2] ) ) ) ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen21 & : ( >= ?gen21 1 ) ) ) ?gen24 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen23 & : ( >= ?gen23 1 ) ) ) ?gen15 <- ( crime_art143 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen17 & : ( not ( member$ rule2 $?gen17 ) ) ) ) ( test ( eq ( class ?gen15 ) crime_art143 ) ) => ?gen15 <- ( crime_art143 ( positive 1 ) ( positive-derivator rule2 ?gen22 ?gen24 ) )"))

([rule2-overruled-dot] of derived-attribute-rule
   (pos-name rule2-overruled-dot-gen2272)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule2] ) ) ) ?gen15 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen18 ) ( negative-overruled $?gen19 & : ( subseq-pos ( create$ rule2-overruled $?gen18 $$$ $?gen19 ) ) ) ) ( test ( eq ( class ?gen15 ) crime_art143 ) ) ( not ( and ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen21 & : ( >= ?gen21 1 ) ) ) ?gen24 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen23 & : ( >= ?gen23 1 ) ) ) ?gen15 <- ( crime_art143 ( positive-defeated $?gen17 & : ( not ( member$ rule2 $?gen17 ) ) ) ) ) ) => ( calc ( bind $?gen20 ( delete-member$ $?gen19 ( create$ rule2-overruled $?gen18 ) ) ) ) ?gen15 <- ( crime_art143 ( negative-overruled $?gen20 ) )"))

([rule2-overruled] of derived-attribute-rule
   (pos-name rule2-overruled-gen2274)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule2] ) ) ) ?gen22 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen21 & : ( >= ?gen21 1 ) ) ) ?gen24 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ( positive ?gen23 & : ( >= ?gen23 1 ) ) ) ?gen15 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen18 ) ( negative-overruled $?gen19 & : ( not ( subseq-pos ( create$ rule2-overruled $?gen18 $$$ $?gen19 ) ) ) ) ( positive-defeated $?gen17 & : ( not ( member$ rule2 $?gen17 ) ) ) ) ( test ( eq ( class ?gen15 ) crime_art143 ) ) => ( calc ( bind $?gen20 ( create$ rule2-overruled $?gen18 $?gen19 ) ) ) ?gen15 <- ( crime_art143 ( negative-overruled $?gen20 ) )"))

([rule2-support] of derived-attribute-rule
   (pos-name rule2-support-gen2276)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule2] ) ) ) ?gen13 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen14 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ?gen15 <- ( crime_art143 ( defendant ?Defendant ) ( positive-support $?gen17 & : ( not ( subseq-pos ( create$ rule2 ?gen13 ?gen14 $$$ $?gen17 ) ) ) ) ) ( test ( eq ( class ?gen15 ) crime_art143 ) ) => ( calc ( bind $?gen20 ( create$ rule2 ?gen13 ?gen14 $?gen17 ) ) ) ?gen15 <- ( crime_art143 ( positive-support $?gen20 ) )"))

([rule1-defeasibly-dot] of derived-attribute-rule
   (pos-name rule1-defeasibly-dot-gen2278)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -1 [rule1] ) ) ) ?gen3 <- ( crime_art143 ( defendant ?Defendant ) ( positive 1 ) ( positive-derivator rule1 $? ) ) ( test ( eq ( class ?gen3 ) crime_art143 ) ) ( not ( and ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen9 & : ( >= ?gen9 1 ) ) ) ?gen12 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen11 & : ( >= ?gen11 1 ) ) ) ?gen3 <- ( crime_art143 ( negative ~ 2 ) ( positive-overruled $?gen5 & : ( not ( member$ rule1 $?gen5 ) ) ) ) ) ) => ?gen3 <- ( crime_art143 ( positive 0 ) )"))

([rule1-defeasibly] of derived-attribute-rule
   (pos-name rule1-defeasibly-gen2280)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 1 [rule1] ) ) ) ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen9 & : ( >= ?gen9 1 ) ) ) ?gen12 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen11 & : ( >= ?gen11 1 ) ) ) ?gen3 <- ( crime_art143 ( defendant ?Defendant ) ( positive 0 ) ( negative ~ 2 ) ( positive-overruled $?gen5 & : ( not ( member$ rule1 $?gen5 ) ) ) ) ( test ( eq ( class ?gen3 ) crime_art143 ) ) => ?gen3 <- ( crime_art143 ( positive 1 ) ( positive-derivator rule1 ?gen10 ?gen12 ) )"))

([rule1-overruled-dot] of derived-attribute-rule
   (pos-name rule1-overruled-dot-gen2282)
   (depends-on declare crime_art143 lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority -2 [rule1] ) ) ) ?gen3 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen6 ) ( negative-overruled $?gen7 & : ( subseq-pos ( create$ rule1-overruled $?gen6 $$$ $?gen7 ) ) ) ) ( test ( eq ( class ?gen3 ) crime_art143 ) ) ( not ( and ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen9 & : ( >= ?gen9 1 ) ) ) ?gen12 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen11 & : ( >= ?gen11 1 ) ) ) ?gen3 <- ( crime_art143 ( positive-defeated $?gen5 & : ( not ( member$ rule1 $?gen5 ) ) ) ) ) ) => ( calc ( bind $?gen8 ( delete-member$ $?gen7 ( create$ rule1-overruled $?gen6 ) ) ) ) ?gen3 <- ( crime_art143 ( negative-overruled $?gen8 ) )"))

([rule1-overruled] of derived-attribute-rule
   (pos-name rule1-overruled-gen2284)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 2 [rule1] ) ) ) ?gen10 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ( positive ?gen9 & : ( >= ?gen9 1 ) ) ) ?gen12 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ( positive ?gen11 & : ( >= ?gen11 1 ) ) ) ?gen3 <- ( crime_art143 ( defendant ?Defendant ) ( negative-support $?gen6 ) ( negative-overruled $?gen7 & : ( not ( subseq-pos ( create$ rule1-overruled $?gen6 $$$ $?gen7 ) ) ) ) ( positive-defeated $?gen5 & : ( not ( member$ rule1 $?gen5 ) ) ) ) ( test ( eq ( class ?gen3 ) crime_art143 ) ) => ( calc ( bind $?gen8 ( create$ rule1-overruled $?gen6 $?gen7 ) ) ) ?gen3 <- ( crime_art143 ( negative-overruled $?gen8 ) )"))

([rule1-support] of derived-attribute-rule
   (pos-name rule1-support-gen2286)
   (depends-on declare lc:case lc:case crime_art143)
   (implies crime_art143)
   (del-name nil)
   (derived-attribute-rule "( declare ( priority ( calc-defeasible-priority 5 [rule1] ) ) ) ?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen2 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ?gen3 <- ( crime_art143 ( defendant ?Defendant ) ( positive-support $?gen5 & : ( not ( subseq-pos ( create$ rule1 ?gen1 ?gen2 $$$ $?gen5 ) ) ) ) ) ( test ( eq ( class ?gen3 ) crime_art143 ) ) => ( calc ( bind $?gen8 ( create$ rule1 ?gen1 ?gen2 $?gen5 ) ) ) ?gen3 <- ( crime_art143 ( positive-support $?gen8 ) )"))

([rule73b-deductive] of ntm-deductive-rule
   (pos-name rule73b-deductive-gen1427)
   (depends-on lc:case lc:case or crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen1327 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1328 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1329 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule73b-deductive-gen1427 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1327 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1328 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen1329 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule73-deductive] of ntm-deductive-rule
   (pos-name rule73-deductive-gen1426)
   (depends-on lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (deductive-rule "?gen1312 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1313 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1314 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_4 ( defendant ?Defendant ) ) ) => ( crime_art149_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule73-deductive-gen1426 ( declare ( salience ( calc-salience crime_art149_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1312 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1313 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen1314 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_4))

([rule72b-deductive] of ntm-deductive-rule
   (pos-name rule72b-deductive-gen1425)
   (depends-on lc:case lc:case or crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen1297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1299 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule72b-deductive-gen1425 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1297 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1298 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen1299 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule72-deductive] of ntm-deductive-rule
   (pos-name rule72-deductive-gen1424)
   (depends-on lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (deductive-rule "?gen1282 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1283 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1284 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_4 ( defendant ?Defendant ) ) ) => ( crime_art149_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule72-deductive-gen1424 ( declare ( salience ( calc-salience crime_art149_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1282 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1283 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen1284 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_4))

([rule71-deductive] of ntm-deductive-rule
   (pos-name rule71-deductive-gen1423)
   (depends-on lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (deductive-rule "?gen1255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen1257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen1258 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1259 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen1260 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1261 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ( not ( crime_art149_1 ( defendant ?Defendant ) ) ) => ( crime_art149_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule71-deductive-gen1423 ( declare ( salience ( calc-salience crime_art149_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1255 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1256 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( object ( name ?gen1257 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen1258 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen1259 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( object ( name ?gen1260 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen1261 ) ( is-a and ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ( not ( object ( is-a crime_art149_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_1))

([rule70-deductive] of ntm-deductive-rule
   (pos-name rule70-deductive-gen1422)
   (depends-on lc:case lc:case lc:case lc:case lc:case lc:case and crime_art149_1)
   (implies crime_art149_1)
   (deductive-rule "?gen1228 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen1229 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen1230 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen1231 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen1232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen1233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen1234 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ( not ( crime_art149_1 ( defendant ?Defendant ) ) ) => ( crime_art149_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule70-deductive-gen1422 ( declare ( salience ( calc-salience crime_art149_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1228 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen1229 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( object ( name ?gen1230 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen1231 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen1232 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( object ( name ?gen1233 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen1234 ) ( is-a and ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ) ( not ( object ( is-a crime_art149_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_1))

([rule69-deductive] of ntm-deductive-rule
   (pos-name rule69-deductive-gen1421)
   (depends-on lc:case lc:case lc:case lc:case crime_art157_3)
   (implies crime_art157_3)
   (deductive-rule "?gen1210 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1211 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1212 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen1213 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( crime_art157_3 ( defendant ?Defendant ) ) ) => ( crime_art157_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule69-deductive-gen1421 ( declare ( salience ( calc-salience crime_art157_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1210 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1211 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ( object ( name ?gen1212 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( object ( name ?gen1213 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( object ( is-a crime_art157_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art157_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art157_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art157_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art157_3))

([rule68-deductive] of ntm-deductive-rule
   (pos-name rule68-deductive-gen1420)
   (depends-on lc:case lc:case lc:case lc:case crime_art157_2)
   (implies crime_art157_2)
   (deductive-rule "?gen1192 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1194 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ?gen1195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( crime_art157_2 ( defendant ?Defendant ) ) ) => ( crime_art157_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule68-deductive-gen1420 ( declare ( salience ( calc-salience crime_art157_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1192 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1193 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ( object ( name ?gen1194 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( object ( name ?gen1195 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( object ( is-a crime_art157_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art157_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art157_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art157_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art157_2))

([rule67-deductive] of ntm-deductive-rule
   (pos-name rule67-deductive-gen1419)
   (depends-on lc:case lc:case lc:case crime_art157)
   (implies crime_art157)
   (deductive-rule "?gen1177 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1178 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ?gen1179 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( not ( crime_art157 ( defendant ?Defendant ) ) ) => ( crime_art157 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule67-deductive-gen1419 ( declare ( salience ( calc-salience crime_art157 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1177 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1178 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"prolaznik\" ) ) ( object ( name ?gen1179 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:help_provision_ability \"mogao_bez_opasnosti\" ) ) ( not ( object ( is-a crime_art157 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art157 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art157 ?Defendant ) ) ) ( make-instance ?oid of crime_art157 ( defendant ?Defendant ) ) )")
   (derived-class crime_art157))

([rule66-deductive] of ntm-deductive-rule
   (pos-name rule66-deductive-gen1418)
   (depends-on lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (deductive-rule "?gen1162 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1163 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen1164 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( crime_art156_3 ( defendant ?Defendant ) ) ) => ( crime_art156_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule66-deductive-gen1418 ( declare ( salience ( calc-salience crime_art156_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1162 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1163 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( object ( name ?gen1164 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( object ( is-a crime_art156_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art156_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156_3))

([rule65-deductive] of ntm-deductive-rule
   (pos-name rule65-deductive-gen1417)
   (depends-on lc:case lc:case lc:case crime_art156_3)
   (implies crime_art156_3)
   (deductive-rule "?gen1147 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1148 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen1149 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( crime_art156_3 ( defendant ?Defendant ) ) ) => ( crime_art156_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule65-deductive-gen1417 ( declare ( salience ( calc-salience crime_art156_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1147 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1148 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( object ( name ?gen1149 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( object ( is-a crime_art156_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art156_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156_3))

([rule64-deductive] of ntm-deductive-rule
   (pos-name rule64-deductive-gen1416)
   (depends-on lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (deductive-rule "?gen1132 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1133 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ?gen1134 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( crime_art156_2 ( defendant ?Defendant ) ) ) => ( crime_art156_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule64-deductive-gen1416 ( declare ( salience ( calc-salience crime_art156_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1132 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1133 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( object ( name ?gen1134 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( object ( is-a crime_art156_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art156_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156_2))

([rule63-deductive] of ntm-deductive-rule
   (pos-name rule63-deductive-gen1415)
   (depends-on lc:case lc:case lc:case crime_art156_2)
   (implies crime_art156_2)
   (deductive-rule "?gen1117 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1118 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ?gen1119 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( crime_art156_2 ( defendant ?Defendant ) ) ) => ( crime_art156_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule63-deductive-gen1415 ( declare ( salience ( calc-salience crime_art156_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1117 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1118 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( object ( name ?gen1119 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"teska_tjelesna_povreda\" ) ) ( not ( object ( is-a crime_art156_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art156_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156_2))

([rule62-deductive] of ntm-deductive-rule
   (pos-name rule62-deductive-gen1414)
   (depends-on lc:case lc:case crime_art156)
   (implies crime_art156)
   (deductive-rule "?gen1105 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1106 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( not ( crime_art156 ( defendant ?Defendant ) ) ) => ( crime_art156 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule62-deductive-gen1414 ( declare ( salience ( calc-salience crime_art156 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1105 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1106 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"duznost_staranja\" ) ) ( not ( object ( is-a crime_art156 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ( make-instance ?oid of crime_art156 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156))

([rule61-deductive] of ntm-deductive-rule
   (pos-name rule61-deductive-gen1413)
   (depends-on lc:case lc:case crime_art156)
   (implies crime_art156)
   (deductive-rule "?gen1093 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1094 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( not ( crime_art156 ( defendant ?Defendant ) ) ) => ( crime_art156 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule61-deductive-gen1413 ( declare ( salience ( calc-salience crime_art156 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1093 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1094 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_victim_relationship \"povjereno_nemocno_lice\" ) ) ( not ( object ( is-a crime_art156 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art156 ?Defendant ) ) ) ( make-instance ?oid of crime_art156 ( defendant ?Defendant ) ) )")
   (derived-class crime_art156))

([rule60-deductive] of ntm-deductive-rule
   (pos-name rule60-deductive-gen1412)
   (depends-on or lc:case lc:case lc:case crime_art155_3)
   (implies crime_art155_3)
   (deductive-rule "?gen1075 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ?gen1076 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1077 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1078 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( crime_art155_3 ( defendant ?Defendant ) ) ) => ( crime_art155_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule60-deductive-gen1412 ( declare ( salience ( calc-salience crime_art155_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1075 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ( object ( name ?gen1076 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ( object ( name ?gen1077 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1078 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"smrt\" ) ) ( not ( object ( is-a crime_art155_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_3))

([rule59-deductive] of ntm-deductive-rule
   (pos-name rule59-deductive-gen1411)
   (depends-on or lc:case lc:case lc:case crime_art155_2)
   (implies crime_art155_2)
   (deductive-rule "?gen1057 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ) ?gen1058 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1059 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1060 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ) ( not ( crime_art155_2 ( defendant ?Defendant ) ) ) => ( crime_art155_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule59-deductive-gen1411 ( declare ( salience ( calc-salience crime_art155_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1057 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ) ( object ( name ?gen1058 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ( object ( name ?gen1059 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1060 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:failure_to_help_consequence \"tesko_narusavanje_zdravlja\" ) ) ( not ( object ( is-a crime_art155_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_2))

([rule58-deductive] of ntm-deductive-rule
   (pos-name rule58-deductive-gen1410)
   (depends-on lc:case lc:case or crime_art155_1)
   (implies crime_art155_1)
   (deductive-rule "?gen1042 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ?gen1043 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ?gen1044 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ( not ( crime_art155_1 ( defendant ?Defendant ) ) ) => ( crime_art155_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule58-deductive-gen1410 ( declare ( salience ( calc-salience crime_art155_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1042 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:left_without_help \"true\" ) ) ( object ( name ?gen1043 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_caused_by_offender \"true\" ) ) ( object ( name ?gen1044 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_life \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_health \"true\" ) ) ) ( not ( object ( is-a crime_art155_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art155_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art155_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art155_1))

([rule57b-deductive] of ntm-deductive-rule
   (pos-name rule57b-deductive-gen1409)
   (depends-on lc:case lc:case crime_art154)
   (implies crime_art154)
   (deductive-rule "?gen1030 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1031 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( not ( crime_art154 ( defendant ?Defendant ) ) ) => ( crime_art154 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule57b-deductive-gen1409 ( declare ( salience ( calc-salience crime_art154 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1030 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( object ( name ?gen1031 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( not ( object ( is-a crime_art154 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ( make-instance ?oid of crime_art154 ( defendant ?Defendant ) ) )")
   (derived-class crime_art154))

([rule57-deductive] of ntm-deductive-rule
   (pos-name rule57-deductive-gen1408)
   (depends-on lc:case lc:case crime_art154)
   (implies crime_art154)
   (deductive-rule "?gen1018 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1019 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( not ( crime_art154 ( defendant ?Defendant ) ) ) => ( crime_art154 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule57-deductive-gen1408 ( declare ( salience ( calc-salience crime_art154 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1018 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( object ( name ?gen1019 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( not ( object ( is-a crime_art154 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ( make-instance ?oid of crime_art154 ( defendant ?Defendant ) ) )")
   (derived-class crime_art154))

([rule56-deductive] of ntm-deductive-rule
   (pos-name rule56-deductive-gen1407)
   (depends-on lc:case lc:case crime_art154)
   (implies crime_art154)
   (deductive-rule "?gen1006 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen1007 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art154 ( defendant ?Defendant ) ) ) => ( crime_art154 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule56-deductive-gen1407 ( declare ( salience ( calc-salience crime_art154 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1006 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( object ( name ?gen1007 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art154 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art154 ?Defendant ) ) ) ( make-instance ?oid of crime_art154 ( defendant ?Defendant ) ) )")
   (derived-class crime_art154))

([rule55-deductive] of ntm-deductive-rule
   (pos-name rule55-deductive-gen1406)
   (depends-on lc:case lc:case crime_art153)
   (implies crime_art153)
   (deductive-rule "?gen994 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen995 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( crime_art153 ( defendant ?Defendant ) ) ) => ( crime_art153 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule55-deductive-gen1406 ( declare ( salience ( calc-salience crime_art153 ) ) ) ( run-deductive-rules ) ( object ( name ?gen994 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( object ( name ?gen995 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( object ( is-a crime_art153 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ( make-instance ?oid of crime_art153 ( defendant ?Defendant ) ) )")
   (derived-class crime_art153))

([rule54-deductive] of ntm-deductive-rule
   (pos-name rule54-deductive-gen1405)
   (depends-on lc:case lc:case crime_art153)
   (implies crime_art153)
   (deductive-rule "?gen982 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ?gen983 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( crime_art153 ( defendant ?Defendant ) ) ) => ( crime_art153 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule54-deductive-gen1405 ( declare ( salience ( calc-salience crime_art153 ) ) ) ( run-deductive-rules ) ( object ( name ?gen982 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:fight_participation \"true\" ) ) ( object ( name ?gen983 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( object ( is-a crime_art153 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art153 ?Defendant ) ) ) ( make-instance ?oid of crime_art153 ( defendant ?Defendant ) ) )")
   (derived-class crime_art153))

([rule53b-deductive] of ntm-deductive-rule
   (pos-name rule53b-deductive-gen1404)
   (depends-on lc:case lc:case or crime_art152_3)
   (implies crime_art152_3)
   (deductive-rule "?gen967 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen968 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ?gen969 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ) ( not ( crime_art152_3 ( defendant ?Defendant ) ) ) => ( crime_art152_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule53b-deductive-gen1404 ( declare ( salience ( calc-salience crime_art152_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen967 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( object ( name ?gen968 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation \"true\" ) ) ( object ( name ?gen969 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ) ( not ( object ( is-a crime_art152_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_3))

([rule53-deductive] of ntm-deductive-rule
   (pos-name rule53-deductive-gen1403)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen955 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ?gen956 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule53-deductive-gen1403 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen955 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_means_type \"sredstvo_podobno_za_tesku_povredu\" ) ) ( object ( name ?gen956 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule52-deductive] of ntm-deductive-rule
   (pos-name rule52-deductive-gen1402)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen943 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ?gen944 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule52-deductive-gen1402 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen943 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_means_type \"opasno_orudje\" ) ) ( object ( name ?gen944 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_severity_level \"laka\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule51-deductive] of ntm-deductive-rule
   (pos-name rule51-deductive-gen1401)
   (depends-on lc:case lc:case crime_art152_2)
   (implies crime_art152_2)
   (deductive-rule "?gen931 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ?gen932 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( crime_art152_2 ( defendant ?Defendant ) ) ) => ( crime_art152_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule51-deductive-gen1401 ( declare ( salience ( calc-salience crime_art152_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen931 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( object ( name ?gen932 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:weapon_used \"true\" ) ) ( not ( object ( is-a crime_art152_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_2))

([rule50-deductive] of ntm-deductive-rule
   (pos-name rule50-deductive-gen1400)
   (depends-on lc:case crime_art152_1)
   (implies crime_art152_1)
   (deductive-rule "?gen922 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( crime_art152_1 ( defendant ?Defendant ) ) ) => ( crime_art152_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule50-deductive-gen1400 ( declare ( salience ( calc-salience crime_art152_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen922 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"laka tjelesna povreda\" ) ) ( not ( object ( is-a crime_art152_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art152_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art152_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art152_1))

([rule49-deductive] of ntm-deductive-rule
   (pos-name rule49-deductive-gen1399)
   (depends-on lc:case lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (deductive-rule "?gen907 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ?gen908 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ?gen909 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( crime_art151b ( defendant ?Defendant ) ) ) => ( crime_art151b ( defendant ?Defendant ) )")
   (production-rule "( defrule rule49-deductive-gen1399 ( declare ( salience ( calc-salience crime_art151b ) ) ) ( run-deductive-rules ) ( object ( name ?gen907 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ( object ( name ?gen908 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:sterilization_goal \"onemogucavanje_reprodukcije\" ) ) ( object ( name ?gen909 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( object ( is-a crime_art151b ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ( make-instance ?oid of crime_art151b ( defendant ?Defendant ) ) )")
   (derived-class crime_art151b))

([rule48-deductive] of ntm-deductive-rule
   (pos-name rule48-deductive-gen1398)
   (depends-on lc:case lc:case crime_art151b)
   (implies crime_art151b)
   (deductive-rule "?gen895 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ?gen896 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( crime_art151b ( defendant ?Defendant ) ) ) => ( crime_art151b ( defendant ?Defendant ) )")
   (production-rule "( defrule rule48-deductive-gen1398 ( declare ( salience ( calc-salience crime_art151b ) ) ) ( run-deductive-rules ) ( object ( name ?gen895 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"prisilna_sterilizacija\" ) ) ( object ( name ?gen896 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( object ( is-a crime_art151b ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151b ?Defendant ) ) ) ( make-instance ?oid of crime_art151b ( defendant ?Defendant ) ) )")
   (derived-class crime_art151b))

([rule47-deductive] of ntm-deductive-rule
   (pos-name rule47-deductive-gen1397)
   (depends-on lc:case crime_art151a)
   (implies crime_art151a)
   (deductive-rule "?gen886 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ( not ( crime_art151a ( defendant ?Defendant ) ) ) => ( crime_art151a ( defendant ?Defendant ) )")
   (production-rule "( defrule rule47-deductive-gen1397 ( declare ( salience ( calc-salience crime_art151a ) ) ) ( run-deductive-rules ) ( object ( name ?gen886 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"sakacenje_zenskih_genitalija\" ) ) ( not ( object ( is-a crime_art151a ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151a ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151a ?Defendant ) ) ) ( make-instance ?oid of crime_art151a ( defendant ?Defendant ) ) )")
   (derived-class crime_art151a))

([rule46b-deductive] of ntm-deductive-rule
   (pos-name rule46b-deductive-gen1396)
   (depends-on lc:case lc:case or lc:case lc:case or lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (deductive-rule "?gen856 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen857 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen858 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ?gen859 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen860 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen861 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ) ?gen862 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen863 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( crime_art151_5 ( defendant ?Defendant ) ) ) => ( crime_art151_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule46b-deductive-gen1396 ( declare ( salience ( calc-salience crime_art151_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen856 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen857 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen858 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ( object ( name ?gen859 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ( object ( name ?gen860 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( object ( name ?gen861 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ) ( object ( name ?gen862 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( object ( name ?gen863 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( object ( is-a crime_art151_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_5))

([rule46-deductive] of ntm-deductive-rule
   (pos-name rule46-deductive-gen1395)
   (depends-on lc:case lc:case or lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case lc:case crime_art151_5)
   (implies crime_art151_5)
   (deductive-rule "?gen811 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen812 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen813 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ?gen814 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen815 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ?gen816 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ?gen817 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ?gen818 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ?gen819 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ?gen820 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ?gen821 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ?gen822 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ?gen823 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( crime_art151_5 ( defendant ?Defendant ) ) ) => ( crime_art151_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule46-deductive-gen1395 ( declare ( salience ( calc-salience crime_art151_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen811 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen812 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen813 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ) ( object ( name ?gen814 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ( object ( name ?gen815 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( object ( name ?gen816 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( object ( name ?gen817 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( object ( name ?gen818 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( object ( name ?gen819 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( object ( name ?gen820 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( object ( name ?gen821 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( object ( name ?gen822 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( object ( name ?gen823 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( object ( is-a crime_art151_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_5))

([rule45-deductive] of ntm-deductive-rule
   (pos-name rule45-deductive-gen1394)
   (depends-on lc:case lc:case crime_art151_4)
   (implies crime_art151_4)
   (deductive-rule "?gen799 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen800 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( crime_art151_4 ( defendant ?Defendant ) ) ) => ( crime_art151_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule45-deductive-gen1394 ( declare ( salience ( calc-salience crime_art151_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen799 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen800 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:negligence \"true\" ) ) ( not ( object ( is-a crime_art151_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_4))

([rule44-deductive] of ntm-deductive-rule
   (pos-name rule44-deductive-gen1393)
   (depends-on lc:case lc:case crime_art151_3)
   (implies crime_art151_3)
   (deductive-rule "?gen787 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen788 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( crime_art151_3 ( defendant ?Defendant ) ) ) => ( crime_art151_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule44-deductive-gen1393 ( declare ( salience ( calc-salience crime_art151_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen787 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen788 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:death_result \"true\" ) ) ( not ( object ( is-a crime_art151_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_3))

([rule43f-deductive] of ntm-deductive-rule
   (pos-name rule43f-deductive-gen1392)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen775 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen776 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43f-deductive-gen1392 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen775 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen776 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unakazenost\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule43e-deductive] of ntm-deductive-rule
   (pos-name rule43e-deductive-gen1391)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen763 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen764 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43e-deductive-gen1391 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen763 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen764 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_naruseno_zdravlje\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule43d-deductive] of ntm-deductive-rule
   (pos-name rule43d-deductive-gen1390)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen751 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen752 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43d-deductive-gen1390 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen751 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen752 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajna_nesposobnost_za_rad\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule43c-deductive] of ntm-deductive-rule
   (pos-name rule43c-deductive-gen1389)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen739 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen740 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43c-deductive-gen1389 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen739 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen740 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"trajno_ostecenje_organa\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule43b-deductive] of ntm-deductive-rule
   (pos-name rule43b-deductive-gen1388)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen727 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen728 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43b-deductive-gen1388 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen727 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen728 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"unistenje_dijela_tijela\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule43-deductive] of ntm-deductive-rule
   (pos-name rule43-deductive-gen1387)
   (depends-on lc:case lc:case crime_art151_2)
   (implies crime_art151_2)
   (deductive-rule "?gen715 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ?gen716 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( not ( crime_art151_2 ( defendant ?Defendant ) ) ) => ( crime_art151_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule43-deductive-gen1387 ( declare ( salience ( calc-salience crime_art151_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen715 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( object ( name ?gen716 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:severe_injury_specific_consequences \"opasnost_po_zivot\" ) ) ( not ( object ( is-a crime_art151_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_2))

([rule41-deductive] of ntm-deductive-rule
   (pos-name rule41-deductive-gen1386)
   (depends-on lc:case crime_art151_1)
   (implies crime_art151_1)
   (deductive-rule "?gen706 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( crime_art151_1 ( defendant ?Defendant ) ) ) => ( crime_art151_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule41-deductive-gen1386 ( declare ( salience ( calc-salience crime_art151_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen706 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:injury_type \"teska tjelesna povreda\" ) ) ( not ( object ( is-a crime_art151_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art151_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art151_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art151_1))

([rule40b-deductive] of ntm-deductive-rule
   (pos-name rule40b-deductive-gen1385)
   (depends-on lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (deductive-rule "?gen688 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen689 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ?gen690 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ) ?gen691 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( crime_art150_3 ( defendant ?Defendant ) ) ) => ( crime_art150_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule40b-deductive-gen1385 ( declare ( salience ( calc-salience crime_art150_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen688 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen689 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ( object ( name ?gen690 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"teska_tjelesna_povreda\" ) ) ( object ( name ?gen691 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( object ( is-a crime_art150_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_3))

([rule39b-deductive] of ntm-deductive-rule
   (pos-name rule39b-deductive-gen1384)
   (depends-on lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (deductive-rule "?gen670 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen671 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ?gen672 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ) ?gen673 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( crime_art150_3 ( defendant ?Defendant ) ) ) => ( crime_art150_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule39b-deductive-gen1384 ( declare ( salience ( calc-salience crime_art150_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen670 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen671 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ) ( object ( name ?gen672 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"tesko_narusavanje_zdravlja\" ) ) ( object ( name ?gen673 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( object ( is-a crime_art150_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_3))

([rule38b-deductive] of ntm-deductive-rule
   (pos-name rule38b-deductive-gen1383)
   (depends-on lc:case lc:case or lc:case lc:case crime_art150_3)
   (implies crime_art150_3)
   (deductive-rule "?gen649 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen650 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen651 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ) ?gen652 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ) ?gen653 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( crime_art150_3 ( defendant ?Defendant ) ) ) => ( crime_art150_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule38b-deductive-gen1383 ( declare ( salience ( calc-salience crime_art150_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen649 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen650 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ( object ( name ?gen651 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ) ( object ( name ?gen652 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_outcomes \"smrt\" ) ) ( object ( name ?gen653 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( not ( object ( is-a crime_art150_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_3))

([rule37-deductive] of ntm-deductive-rule
   (pos-name rule37-deductive-gen1382)
   (depends-on lc:case lc:case or crime_art150_2)
   (implies crime_art150_2)
   (deductive-rule "?gen634 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen635 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ?gen636 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( not ( crime_art150_2 ( defendant ?Defendant ) ) ) => ( crime_art150_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule37-deductive-gen1382 ( declare ( salience ( calc-salience crime_art150_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen634 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen635 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetna_trudnica\" ) ) ( object ( name ?gen636 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guardian_consent \"ne\" ) ) ) ( not ( object ( is-a crime_art150_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_2))

([rule36b-deductive] of ntm-deductive-rule
   (pos-name rule36b-deductive-gen1381)
   (depends-on lc:case lc:case crime_art150_2)
   (implies crime_art150_2)
   (deductive-rule "?gen622 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen623 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( crime_art150_2 ( defendant ?Defendant ) ) ) => ( crime_art150_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule36b-deductive-gen1381 ( declare ( salience ( calc-salience crime_art150_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen622 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen623 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"bez_pristanka\" ) ) ( not ( object ( is-a crime_art150_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_2))

([rule34b-deductive] of ntm-deductive-rule
   (pos-name rule34b-deductive-gen1380)
   (depends-on lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (deductive-rule "?gen607 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen608 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen609 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( not ( crime_art150_1 ( defendant ?Defendant ) ) ) => ( crime_art150_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule34b-deductive-gen1380 ( declare ( salience ( calc-salience crime_art150_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen607 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen608 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ( object ( name ?gen609 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"pomogne_izvrsenje_pobacaja\" ) ) ( not ( object ( is-a crime_art150_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_1))

([rule34-deductive] of ntm-deductive-rule
   (pos-name rule34-deductive-gen1379)
   (depends-on lc:case lc:case lc:case crime_art150_1)
   (implies crime_art150_1)
   (deductive-rule "?gen592 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ?gen593 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ?gen594 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( not ( crime_art150_1 ( defendant ?Defendant ) ) ) => ( crime_art150_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule34-deductive-gen1379 ( declare ( salience ( calc-salience crime_art150_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen592 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"nelegalni_pobacaj\" ) ) ( object ( name ?gen593 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_consent \"pristanak\" ) ) ( object ( name ?gen594 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:abortion_action_mode \"izvrsi_pobacaj\" ) ) ( not ( object ( is-a crime_art150_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art150_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art150_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art150_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art150_1))

([rule33-deductive] of ntm-deductive-rule
   (pos-name rule33-deductive-gen1378)
   (depends-on lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (deductive-rule "?gen574 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ?gen575 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ?gen576 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen577 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ( not ( crime_art149_5 ( defendant ?Defendant ) ) ) => ( crime_art149_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule33-deductive-gen1378 ( declare ( salience ( calc-salience crime_art149_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen574 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ( object ( name ?gen575 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ( object ( name ?gen576 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( object ( name ?gen577 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ( not ( object ( is-a crime_art149_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_5))

([rule32-deductive] of ntm-deductive-rule
   (pos-name rule32-deductive-gen1377)
   (depends-on lc:case lc:case lc:case or crime_art149_5)
   (implies crime_art149_5)
   (deductive-rule "?gen556 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ?gen557 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ?gen558 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen559 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ( not ( crime_art149_5 ( defendant ?Defendant ) ) ) => ( crime_art149_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule32-deductive-gen1377 ( declare ( salience ( calc-salience crime_art149_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen556 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:inhuman_treatment \"true\" ) ) ( object ( name ?gen557 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_subordination \"true\" ) ) ( object ( name ?gen558 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( object ( name ?gen559 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:death_attributed_to_negligence \"da\" ) ) ) ( not ( object ( is-a crime_art149_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_5))

([rule31b-deductive] of ntm-deductive-rule
   (pos-name rule31b-deductive-gen1376)
   (depends-on lc:case lc:case or crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen541 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen542 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen543 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule31b-deductive-gen1376 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen541 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen542 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen543 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule31-deductive] of ntm-deductive-rule
   (pos-name rule31-deductive-gen1375)
   (depends-on lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (deductive-rule "?gen526 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen527 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen528 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_4 ( defendant ?Defendant ) ) ) => ( crime_art149_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule31-deductive-gen1375 ( declare ( salience ( calc-salience crime_art149_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen526 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen527 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen528 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_4))

([rule30b-deductive] of ntm-deductive-rule
   (pos-name rule30b-deductive-gen1374)
   (depends-on lc:case lc:case or crime_art144)
   (implies crime_art144)
   (deductive-rule "?gen511 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen512 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen513 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art144 ( defendant ?Defendant ) ) ) => ( crime_art144 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule30b-deductive-gen1374 ( declare ( salience ( calc-salience crime_art144 ) ) ) ( run-deductive-rules ) ( object ( name ?gen511 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen512 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen513 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art144 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144 ?Defendant ) ) ) ( make-instance ?oid of crime_art144 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144))

([rule30-deductive] of ntm-deductive-rule
   (pos-name rule30-deductive-gen1373)
   (depends-on lc:case lc:case or crime_art149_4)
   (implies crime_art149_4)
   (deductive-rule "?gen496 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen497 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen498 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_4 ( defendant ?Defendant ) ) ) => ( crime_art149_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule30-deductive-gen1373 ( declare ( salience ( calc-salience crime_art149_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen496 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen497 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen498 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_4))

([rule29-deductive] of ntm-deductive-rule
   (pos-name rule29-deductive-gen1372)
   (depends-on lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (deductive-rule "?gen481 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen482 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen483 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_3 ( defendant ?Defendant ) ) ) => ( crime_art149_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule29-deductive-gen1372 ( declare ( salience ( calc-salience crime_art149_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen481 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen482 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( object ( name ?gen483 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_3))

([rule28b-deductive] of ntm-deductive-rule
   (pos-name rule28b-deductive-gen1371)
   (depends-on lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (deductive-rule "?gen466 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen467 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen468 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_3 ( defendant ?Defendant ) ) ) => ( crime_art149_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule28b-deductive-gen1371 ( declare ( salience ( calc-salience crime_art149_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen466 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen467 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen468 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_3))

([rule28-deductive] of ntm-deductive-rule
   (pos-name rule28-deductive-gen1370)
   (depends-on lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (deductive-rule "?gen451 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen452 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen453 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_3 ( defendant ?Defendant ) ) ) => ( crime_art149_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule28-deductive-gen1370 ( declare ( salience ( calc-salience crime_art149_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen451 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen452 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen453 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_3))

([rule29b-deductive] of ntm-deductive-rule
   (pos-name rule29b-deductive-gen1369)
   (depends-on lc:case lc:case or crime_art149_3)
   (implies crime_art149_3)
   (deductive-rule "?gen436 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen437 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ?gen438 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( crime_art149_3 ( defendant ?Defendant ) ) ) => ( crime_art149_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule29b-deductive-gen1369 ( declare ( salience ( calc-salience crime_art149_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen436 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen437 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( object ( name ?gen438 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ) ( not ( object ( is-a crime_art149_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_3))

([rule27-deductive] of ntm-deductive-rule
   (pos-name rule27-deductive-gen1368)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (deductive-rule "?gen415 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen416 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen417 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen418 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen419 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( not ( crime_art149_2 ( defendant ?Defendant ) ) ) => ( crime_art149_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule27-deductive-gen1368 ( declare ( salience ( calc-salience crime_art149_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen415 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen416 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( object ( name ?gen417 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( object ( name ?gen418 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( object ( name ?gen419 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( not ( object ( is-a crime_art149_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_2))

([rule26-deductive] of ntm-deductive-rule
   (pos-name rule26-deductive-gen1367)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art149_2)
   (implies crime_art149_2)
   (deductive-rule "?gen394 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ?gen395 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen396 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen397 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen398 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( not ( crime_art149_2 ( defendant ?Defendant ) ) ) => ( crime_art149_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule26-deductive-gen1367 ( declare ( salience ( calc-salience crime_art149_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen394 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"pomaganje_u_samoubistvu\" ) ) ( object ( name ?gen395 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( object ( name ?gen396 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( object ( name ?gen397 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( object ( name ?gen398 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( not ( object ( is-a crime_art149_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_2))

([rule25-deductive] of ntm-deductive-rule
   (pos-name rule25-deductive-gen1366)
   (depends-on lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (deductive-rule "?gen370 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen371 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ?gen372 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen373 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen374 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen375 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( not ( crime_art149_1 ( defendant ?Defendant ) ) ) => ( crime_art149_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule25-deductive-gen1366 ( declare ( salience ( calc-salience crime_art149_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen370 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen371 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"pokusano\" ) ) ( object ( name ?gen372 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen373 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen374 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen375 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( not ( object ( is-a crime_art149_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_1))

([rule24-deductive] of ntm-deductive-rule
   (pos-name rule24-deductive-gen1365)
   (depends-on lc:case lc:case lc:case lc:case lc:case lc:case crime_art149_1)
   (implies crime_art149_1)
   (deductive-rule "?gen346 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ?gen347 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ?gen348 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ?gen349 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ?gen350 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ?gen351 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( not ( crime_art149_1 ( defendant ?Defendant ) ) ) => ( crime_art149_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule24-deductive-gen1365 ( declare ( salience ( calc-salience crime_art149_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen346 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:special_action_types \"navodjenje_na_samoubistvo\" ) ) ( object ( name ?gen347 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:suicide_outcome \"izvrseno\" ) ) ( object ( name ?gen348 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( object ( name ?gen349 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"maloljetnik\" ) ) ( object ( name ?gen350 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"neuracunljivo\" ) ) ( object ( name ?gen351 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_accountability \"bitno_smanjena_uracunljivost\" ) ) ( not ( object ( is-a crime_art149_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art149_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art149_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art149_1))

([rule22-deductive] of ntm-deductive-rule
   (pos-name rule22-deductive-gen1364)
   (depends-on lc:case lc:case crime_art148)
   (implies crime_art148)
   (deductive-rule "?gen334 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen335 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( crime_art148 ( defendant ?Defendant ) ) ) => ( crime_art148 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule22-deductive-gen1364 ( declare ( salience ( calc-salience crime_art148 ) ) ) ( run-deductive-rules ) ( object ( name ?gen334 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen335 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"nehat\" ) ) ( not ( object ( is-a crime_art148 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art148 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art148 ?Defendant ) ) ) ( make-instance ?oid of crime_art148 ( defendant ?Defendant ) ) )")
   (derived-class crime_art148))

([rule21-deductive] of ntm-deductive-rule
   (pos-name rule21-deductive-gen1363)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art147)
   (implies crime_art147)
   (deductive-rule "?gen313 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen314 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ?gen315 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ?gen316 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ?gen317 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( not ( crime_art147 ( defendant ?Defendant ) ) ) => ( crime_art147 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule21-deductive-gen1363 ( declare ( salience ( calc-salience crime_art147 ) ) ) ( run-deductive-rules ) ( object ( name ?gen313 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen314 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( object ( name ?gen315 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( object ( name ?gen316 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( object ( name ?gen317 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ( not ( object ( is-a crime_art147 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art147 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art147 ?Defendant ) ) ) ( make-instance ?oid of crime_art147 ( defendant ?Defendant ) ) )")
   (derived-class crime_art147))

([rule19-deductive] of ntm-deductive-rule
   (pos-name rule19-deductive-gen1362)
   (depends-on lc:case lc:case lc:case lc:case crime_art146)
   (implies crime_art146)
   (deductive-rule "?gen295 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen296 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ?gen297 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ?gen298 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( crime_art146 ( defendant ?Defendant ) ) ) => ( crime_art146 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule19-deductive-gen1362 ( declare ( salience ( calc-salience crime_art146 ) ) ) ( run-deductive-rules ) ( object ( name ?gen295 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen296 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ( object ( name ?gen297 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_is_mother \"true\" ) ) ( object ( name ?gen298 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( object ( is-a crime_art146 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art146 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art146 ?Defendant ) ) ) ( make-instance ?oid of crime_art146 ( defendant ?Defendant ) ) )")
   (derived-class crime_art146))

([rule18b-deductive] of ntm-deductive-rule
   (pos-name rule18b-deductive-gen1361)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (deductive-rule "?gen274 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen275 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen276 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ?gen277 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen278 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( crime_art145 ( defendant ?Defendant ) ) ) => ( crime_art145 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule18b-deductive-gen1361 ( declare ( salience ( calc-salience crime_art145 ) ) ) ( run-deductive-rules ) ( object ( name ?gen274 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen275 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen276 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"tesko_vrijedjanje_od_ubijenog\" ) ) ( object ( name ?gen277 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ( object ( name ?gen278 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( object ( is-a crime_art145 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ( make-instance ?oid of crime_art145 ( defendant ?Defendant ) ) )")
   (derived-class crime_art145))

([rule18-deductive] of ntm-deductive-rule
   (pos-name rule18-deductive-gen1360)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (deductive-rule "?gen253 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen254 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen255 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ?gen256 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen257 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( crime_art145 ( defendant ?Defendant ) ) ) => ( crime_art145 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule18-deductive-gen1360 ( declare ( salience ( calc-salience crime_art145 ) ) ) ( run-deductive-rules ) ( object ( name ?gen253 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen254 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen255 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"zlostavljanje_od_ubijenog\" ) ) ( object ( name ?gen256 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ( object ( name ?gen257 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( object ( is-a crime_art145 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ( make-instance ?oid of crime_art145 ( defendant ?Defendant ) ) )")
   (derived-class crime_art145))

([rule17-deductive] of ntm-deductive-rule
   (pos-name rule17-deductive-gen1359)
   (depends-on lc:case lc:case lc:case lc:case lc:case crime_art145)
   (implies crime_art145)
   (deductive-rule "?gen232 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen233 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen234 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ?gen235 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ?gen236 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( crime_art145 ( defendant ?Defendant ) ) ) => ( crime_art145 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule17-deductive-gen1359 ( declare ( salience ( calc-salience crime_art145 ) ) ) ( run-deductive-rules ) ( object ( name ?gen232 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen233 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen234 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"napad_od_ubijenog\" ) ) ( object ( name ?gen235 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:provocation_types \"bez_krivice_ucinioca\" ) ) ( object ( name ?gen236 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:high_intensity_distress \"true\" ) ) ( not ( object ( is-a crime_art145 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art145 ?Defendant ) ) ) ( make-instance ?oid of crime_art145 ( defendant ?Defendant ) ) )")
   (derived-class crime_art145))

([rule16-deductive] of ntm-deductive-rule
   (pos-name rule16-deductive-gen1358)
   (depends-on lc:case lc:case or lc:case lc:case and crime_art144_8)
   (implies crime_art144_8)
   (deductive-rule "?gen208 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen209 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ?gen210 <- ( or ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ) ?gen211 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ?gen212 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ?gen213 <- ( and ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ) ( not ( crime_art144_8 ( defendant ?Defendant ) ) ) => ( crime_art144_8 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule16-deductive-gen1358 ( declare ( salience ( calc-salience crime_art144_8 ) ) ) ( run-deductive-rules ) ( object ( name ?gen208 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen209 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_count \"vise\" ) ) ( object ( name ?gen210 ) ( is-a or ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ) ( object ( name ?gen211 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"na_mah\" ) ) ( object ( name ?gen212 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_psych_state \"porodjajni_poremecaj\" ) ) ( object ( name ?gen213 ) ( is-a and ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"punoljetno_lice\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_health_state \"tesko_zdravstveno_stanje\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_explicit_request \"da\" ) ) ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"samilost\" ) ) ) ( not ( object ( is-a crime_art144_8 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_8 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_8 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_8 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_8))

([rule15-deductive] of ntm-deductive-rule
   (pos-name rule15-deductive-gen1357)
   (depends-on lc:case lc:case lc:case crime_art144_7)
   (implies crime_art144_7)
   (deductive-rule "?gen193 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen194 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ) ?gen195 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ) ( not ( crime_art144_7 ( defendant ?Defendant ) ) ) => ( crime_art144_7 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule15-deductive-gen1357 ( declare ( salience ( calc-salience crime_art144_7 ) ) ) ( run-deductive-rules ) ( object ( name ?gen193 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen194 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"clan_porodice\" ) ) ( object ( name ?gen195 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_previously_abused \"true\" ) ) ( not ( object ( is-a crime_art144_7 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_7 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_7 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_7 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_7))

([rule14-deductive] of ntm-deductive-rule
   (pos-name rule14-deductive-gen1356)
   (depends-on lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (deductive-rule "?gen181 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen182 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ( not ( crime_art144_6 ( defendant ?Defendant ) ) ) => ( crime_art144_6 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule14-deductive-gen1356 ( declare ( salience ( calc-salience crime_art144_6 ) ) ) ( run-deductive-rules ) ( object ( name ?gen181 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen182 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"bremenita_zena\" ) ) ( not ( object ( is-a crime_art144_6 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_6 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_6 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_6 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_6))

([rule13-deductive] of ntm-deductive-rule
   (pos-name rule13-deductive-gen1355)
   (depends-on lc:case lc:case crime_art144_6)
   (implies crime_art144_6)
   (deductive-rule "?gen169 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen170 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( crime_art144_6 ( defendant ?Defendant ) ) ) => ( crime_art144_6 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule13-deductive-gen1355 ( declare ( salience ( calc-salience crime_art144_6 ) ) ) ( run-deductive-rules ) ( object ( name ?gen169 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen170 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"dijete\" ) ) ( not ( object ( is-a crime_art144_6 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_6 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_6 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_6 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_6))

([rule12-deductive] of ntm-deductive-rule
   (pos-name rule12-deductive-gen1354)
   (depends-on lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (deductive-rule "?gen154 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen155 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ) ?gen156 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ( not ( crime_art144_5 ( defendant ?Defendant ) ) ) => ( crime_art144_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule12-deductive-gen1354 ( declare ( salience ( calc-salience crime_art144_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen154 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen155 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"vojno_lice\" ) ) ( object ( name ?gen156 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ( not ( object ( is-a crime_art144_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_5))

([rule11-deductive] of ntm-deductive-rule
   (pos-name rule11-deductive-gen1353)
   (depends-on lc:case lc:case lc:case crime_art144_5)
   (implies crime_art144_5)
   (deductive-rule "?gen139 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen140 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ) ?gen141 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ( not ( crime_art144_5 ( defendant ?Defendant ) ) ) => ( crime_art144_5 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule11-deductive-gen1353 ( declare ( salience ( calc-salience crime_art144_5 ) ) ) ( run-deductive-rules ) ( object ( name ?gen139 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen140 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:victim_status \"sluzbeno_lice\" ) ) ( object ( name ?gen141 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:duty_connection \"u_vrsenju_sluzbene_duznosti\" ) ) ( not ( object ( is-a crime_art144_5 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_5 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_5 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_5 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_5))

([rule10-deductive] of ntm-deductive-rule
   (pos-name rule10-deductive-gen1352)
   (depends-on lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (deductive-rule "?gen127 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen128 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ) ( not ( crime_art144_4 ( defendant ?Defendant ) ) ) => ( crime_art144_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule10-deductive-gen1352 ( declare ( salience ( calc-salience crime_art144_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen127 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen128 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_motive \"bezobzirna_osveta\" ) ) ( not ( object ( is-a crime_art144_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_4))

([rule9b-deductive] of ntm-deductive-rule
   (pos-name rule9b-deductive-gen1351)
   (depends-on lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (deductive-rule "?gen115 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen116 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ) ( not ( crime_art144_4 ( defendant ?Defendant ) ) ) => ( crime_art144_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule9b-deductive-gen1351 ( declare ( salience ( calc-salience crime_art144_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen115 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen116 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_motive \"niske_pobude\" ) ) ( not ( object ( is-a crime_art144_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_4))

([rule9-deductive] of ntm-deductive-rule
   (pos-name rule9-deductive-gen1350)
   (depends-on lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (deductive-rule "?gen103 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen104 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ) ( not ( crime_art144_4 ( defendant ?Defendant ) ) ) => ( crime_art144_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule9-deductive-gen1350 ( declare ( salience ( calc-salience crime_art144_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen103 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen104 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_motive \"izvrsenje_ili_prikrivanje_drugog_krivicnog_djela\" ) ) ( not ( object ( is-a crime_art144_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_4))

([rule8-deductive] of ntm-deductive-rule
   (pos-name rule8-deductive-gen1349)
   (depends-on lc:case lc:case crime_art144_4)
   (implies crime_art144_4)
   (deductive-rule "?gen91 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen92 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ) ( not ( crime_art144_4 ( defendant ?Defendant ) ) ) => ( crime_art144_4 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule8-deductive-gen1349 ( declare ( salience ( calc-salience crime_art144_4 ) ) ) ( run-deductive-rules ) ( object ( name ?gen91 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen92 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:offender_motive \"koristoljublje\" ) ) ( not ( object ( is-a crime_art144_4 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_4 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_4 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_4))

([rule7b-deductive] of ntm-deductive-rule
   (pos-name rule7b-deductive-gen1348)
   (depends-on lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (deductive-rule "?gen76 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen77 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ?gen78 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( crime_art144_3 ( defendant ?Defendant ) ) ) => ( crime_art144_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule7b-deductive-gen1348 ( declare ( salience ( calc-salience crime_art144_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen76 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen77 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( object ( name ?gen78 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( object ( is-a crime_art144_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_3))

([rule7-deductive] of ntm-deductive-rule
   (pos-name rule7-deductive-gen1347)
   (depends-on lc:case lc:case lc:case crime_art144_3)
   (implies crime_art144_3)
   (deductive-rule "?gen61 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen62 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ?gen63 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( crime_art144_3 ( defendant ?Defendant ) ) ) => ( crime_art144_3 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule7-deductive-gen1347 ( declare ( salience ( calc-salience crime_art144_3 ) ) ) ( run-deductive-rules ) ( object ( name ?gen61 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen62 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( object ( name ?gen63 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:danger_to_third_parties \"true\" ) ) ( not ( object ( is-a crime_art144_3 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_3 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_3 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_3 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_3))

([rule6-deductive] of ntm-deductive-rule
   (pos-name rule6-deductive-gen1346)
   (depends-on lc:case lc:case crime_art144_2)
   (implies crime_art144_2)
   (deductive-rule "?gen49 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen50 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ) ( not ( crime_art144_2 ( defendant ?Defendant ) ) ) => ( crime_art144_2 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule6-deductive-gen1346 ( declare ( salience ( calc-salience crime_art144_2 ) ) ) ( run-deductive-rules ) ( object ( name ?gen49 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen50 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"bezobzirno_nasilnicko_ponasanje\" ) ) ( not ( object ( is-a crime_art144_2 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_2 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_2 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_2 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_2))

([rule5-deductive] of ntm-deductive-rule
   (pos-name rule5-deductive-gen1345)
   (depends-on lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (deductive-rule "?gen37 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen38 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ) ( not ( crime_art144_1 ( defendant ?Defendant ) ) ) => ( crime_art144_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule5-deductive-gen1345 ( declare ( salience ( calc-salience crime_art144_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen37 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen38 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"podmukao\" ) ) ( not ( object ( is-a crime_art144_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_1))

([rule4-deductive] of ntm-deductive-rule
   (pos-name rule4-deductive-gen1344)
   (depends-on lc:case lc:case crime_art144_1)
   (implies crime_art144_1)
   (deductive-rule "?gen25 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen26 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ) ( not ( crime_art144_1 ( defendant ?Defendant ) ) ) => ( crime_art144_1 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule4-deductive-gen1344 ( declare ( salience ( calc-salience crime_art144_1 ) ) ) ( run-deductive-rules ) ( object ( name ?gen25 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen26 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:execution_manner \"svirep\" ) ) ( not ( object ( is-a crime_art144_1 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art144_1 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art144_1 ?Defendant ) ) ) ( make-instance ?oid of crime_art144_1 ( defendant ?Defendant ) ) )")
   (derived-class crime_art144_1))

([rule2-deductive] of ntm-deductive-rule
   (pos-name rule2-deductive-gen1343)
   (depends-on lc:case lc:case crime_art143)
   (implies crime_art143)
   (deductive-rule "?gen13 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen14 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( not ( crime_art143 ( defendant ?Defendant ) ) ) => ( crime_art143 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule2-deductive-gen1343 ( declare ( salience ( calc-salience crime_art143 ) ) ) ( run-deductive-rules ) ( object ( name ?gen13 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen14 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_eventualni\" ) ) ( not ( object ( is-a crime_art143 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ( make-instance ?oid of crime_art143 ( defendant ?Defendant ) ) )")
   (derived-class crime_art143))

([rule1-deductive] of ntm-deductive-rule
   (pos-name rule1-deductive-gen1342)
   (depends-on lc:case lc:case crime_art143)
   (implies crime_art143)
   (deductive-rule "?gen1 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ?gen2 <- ( lc:case ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( not ( crime_art143 ( defendant ?Defendant ) ) ) => ( crime_art143 ( defendant ?Defendant ) )")
   (production-rule "( defrule rule1-deductive-gen1342 ( declare ( salience ( calc-salience crime_art143 ) ) ) ( run-deductive-rules ) ( object ( name ?gen1 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:life_consequence_type \"smrt_nastupila\" ) ) ( object ( name ?gen2 ) ( is-a lc:case ) ( lc:defendant ?Defendant ) ( lc:guilt_form \"umisljaj_direktni\" ) ) ( not ( object ( is-a crime_art143 ) ( defendant ?Defendant ) ) ) ( test ( not ( instance-existp ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ) ) => ( bind ?oid ( symbol-to-instance-name ( sym-cat crime_art143 ?Defendant ) ) ) ( make-instance ?oid of crime_art143 ( defendant ?Defendant ) ) )")
   (derived-class crime_art143))

