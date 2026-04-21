import { CaseFacts } from '../models/models';

function normToken(value: string | undefined | null): string {
  return (value || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .replace(/[-/]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function compact(value: string | undefined | null): string {
  return normToken(value).replace(/ /g, '_');
}

const ALIASES: Record<string, Record<string, string[]>> = {
  life_consequence_type: {
    smrt_nastupila: ['smrt_nastupila', 'smrt', 'smrtni_ishod', 'nastupila_smrt'],
  },
  guilt_form: {
    umisljaj_direktni: ['umisljaj_direktni', 'direktni_umisljaj', 'direktan_umisljaj'],
    umisljaj_eventualni: ['umisljaj_eventualni', 'eventualni_umisljaj'],
    nehat: ['nehat', 'iz_nehata'],
  },
  execution_manner: {
    svirep: ['svirep', 'svirep_nacin', 'svirepo'],
    podmukao: ['podmukao', 'podmukao_nacin', 'podmuklo'],
    bezobzirno_nasilnicko_ponasanje: ['bezobzirno_nasilnicko_ponasanje', 'bezobzirno_nasilje', 'bezobzirno_nasilnicki'],
    na_mah: ['na_mah', 'afekat', 'u_afektu'],
    upotrebom_sile: ['upotrebom_sile'],
    prijetnjom: ['prijetnjom'],
  },
  victim_consent: {
    pristanak: ['pristanak', 'sa_pristankom', 'uz_pristanak'],
    bez_pristanka: ['bez_pristanka'],
  },
  victim_health_state: {
    tesko_zdravstveno_stanje: ['tesko_zdravstveno_stanje', 'tesko_stanje', 'tesko_oboljenje', 'uredno_zdravlje'],
  },
  victim_status: {
    dijete: ['dijete', 'dete'],
    bremenita_zena: ['bremenita_zena', 'trudnica', 'trudna_zena'],
    sluzbeno_lice: ['sluzbeno_lice'],
    vojno_lice: ['vojno_lice'],
    clan_porodice: ['clan_porodice', 'clan_porodicne_zajednice'],
    punoljetno_lice: ['punoljetno_lice', 'punoljetna_osoba', 'odrasla_osoba'],
    maloljetnik: ['maloljetnik', 'maloletnik'],
    maloljetna_trudnica: ['maloljetna_trudnica', 'maloletna_trudnica'],
    nemocno_lice: ['nemocno_lice', 'nemoćno_lice', 'nemocna_osoba'],
  },
    guardian_consent: {
      da: ['da', 'saglasnost', 'yes', 'true'],
      ne: ['ne', 'bez_saglasnosti', 'no', 'false'],
    },
    abortion_action_mode: {
      izvrsi_pobacaj: ['izvrsi_pobacaj', 'izvrsava_pobacaj', 'izvrsenje_pobacaja'],
      pomogne_izvrsenje_pobacaja: ['pomogne_izvrsenje_pobacaja', 'pomaganje_izvrsenju_pobacaja', 'pomogne_da_izvrsi_pobacaj'],
    },
  victim_accountability: {
    bitno_smanjena_uracunljivost: ['bitno_smanjena_uracunljivost', 'bitno_smanjena', 'smanjena_uracunljivost'],
    uracunljiva: ['uracunljiva'],
    neuracunljivo: ['neuracunljivo', 'neuracunljiva'],
  },
  duty_connection: {
    u_vrsenju_sluzbene_duznosti: ['u_vrsenju_sluzbene_duznosti', 'pri_vrsenju_duznosti', 'u_vezi_sa_vrsenjem_duznosti'],
  },
  offender_motive: {
    izvrsenje_ili_prikrivanje_drugog_krivicnog_djela: ['prikrivanje_drugog_kd', 'izvrsenje_drugog_kd', 'izvrsenje_ili_prikrivanje_drugog_krivicnog_djela'],
    koristoljublje: ['koristoljublje'],
    bezobzirna_osveta: ['bezobzirna_osveta', 'osveta'],
    niske_pobude: ['niske_pobude', 'niske_motive'],
    samilost: ['samilost'],
  },
  abortion_outcomes: {
    pobacaj_izvrsen: ['pobacaj_izvrsen', 'izvrsen_pobacaj'],
    smrt: ['smrt', 'smrt_zene'],
    teska_tjelesna_povreda: ['teska_tjelesna_povreda', 'teska_povreda_zene'],
    tesko_narusavanje_zdravlja: ['tesko_narusavanje_zdravlja', 'teska_povreda_ili_narusenje_zdravlja'],
  },
  injury_means_type: {
    opasno_orudje: ['opasno_orudje', 'oruzje', 'opasno_sredstvo'],
    sredstvo_podobno_za_tesku_povredu: ['sredstvo_podobno_za_tesku_povredu', 'drugo_podobno_sredstvo'],
  },
  severe_injury_specific_consequences: {
    opasnost_po_zivot: ['opasnost_po_zivot', 'doveden_u_opasnost_zivota'],
    unistenje_dijela_tijela: ['unistenje_dijela_tijela'],
    trajno_ostecenje_organa: ['trajno_ostecenje_organa'],
    trajna_nesposobnost_za_rad: ['trajna_nesposobnost_za_rad'],
    trajno_naruseno_zdravlje: ['trajno_naruseno_zdravlje'],
    unakazenost: ['unakazenost'],
  },
  failure_to_help_consequence: {
    tesko_narusavanje_zdravlja: ['tesko_narusavanje_zdravlja', 'teska_povreda_ili_narusenje_zdravlja'],
    teska_tjelesna_povreda: ['teska_tjelesna_povreda', 'teska_povreda'],
    smrt: ['smrt'],
  },
};

function normalizeByAlias(field: string, value: string | undefined | null): string | undefined {
  const raw = compact(value);
  if (!raw) return undefined;
  const fieldAliases = ALIASES[field];
  if (!fieldAliases) return raw;
  for (const [canonical, aliases] of Object.entries(fieldAliases)) {
    if (raw === compact(canonical) || aliases.some((item) => compact(item) === raw)) {
      return canonical;
    }
  }
  return raw;
}

function normalizeList(field: string, values: string[] | undefined): string[] {
  const normalized = (values || [])
    .map((entry) => normalizeByAlias(field, entry))
    .filter((entry): entry is string => !!entry);
  return Array.from(new Set(normalized));
}

export function normalizeRuleFactsInput(facts: CaseFacts): CaseFacts {
  return {
    ...facts,
    life_consequence_type: normalizeByAlias('life_consequence_type', facts.life_consequence_type),
    guilt_form: normalizeByAlias('guilt_form', facts.guilt_form),
    execution_manner: normalizeList('execution_manner', facts.execution_manner),
    victim_consent: normalizeByAlias('victim_consent', facts.victim_consent),
    guardian_consent: normalizeByAlias('guardian_consent', facts.guardian_consent),
    abortion_action_mode: normalizeByAlias('abortion_action_mode', facts.abortion_action_mode),
    victim_health_state: normalizeByAlias('victim_health_state', facts.victim_health_state),
    victim_status: normalizeList('victim_status', facts.victim_status),
    victim_accountability: normalizeByAlias('victim_accountability', facts.victim_accountability),
    duty_connection: normalizeByAlias('duty_connection', facts.duty_connection),
    offender_motive: normalizeList('offender_motive', facts.offender_motive),
    abortion_outcomes: normalizeList('abortion_outcomes', facts.abortion_outcomes),
    injury_means_type: normalizeByAlias('injury_means_type', facts.injury_means_type),
    severe_injury_specific_consequences: normalizeList('severe_injury_specific_consequences', facts.severe_injury_specific_consequences),
    failure_to_help_consequence: normalizeByAlias('failure_to_help_consequence', facts.failure_to_help_consequence),
  };
}
