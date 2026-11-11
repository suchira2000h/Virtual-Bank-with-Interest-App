import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const BankApp());

// ---------------------------------------------------------------- currencies

class Currency {
  final String code, name, symbol;
  const Currency(this.code, this.name, this.symbol);
}

const String _rawCurrencies = r'''
AED|United Arab Emirates Dirham|AED
AFN|Afghan Afghani|؋
ALL|Albanian Lek|L
AMD|Armenian Dram|֏
ANG|Netherlands Antillean Guilder|ƒ
AOA|Angolan Kwanza|Kz
ARS|Argentine Peso|$
AUD|Australian Dollar|A$
AWG|Aruban Florin|ƒ
AZN|Azerbaijani Manat|₼
BAM|Bosnia-Herzegovina Convertible Mark|KM
BBD|Barbadian Dollar|Bds$
BDT|Bangladeshi Taka|৳
BGN|Bulgarian Lev|лв
BHD|Bahraini Dinar|BD
BIF|Burundian Franc|FBu
BMD|Bermudian Dollar|$
BND|Brunei Dollar|B$
BOB|Bolivian Boliviano|Bs
BRL|Brazilian Real|R$
BSD|Bahamian Dollar|B$
BTN|Bhutanese Ngultrum|Nu
BWP|Botswana Pula|P
BYN|Belarusian Ruble|Br
BZD|Belize Dollar|BZ$
CAD|Canadian Dollar|C$
CDF|Congolese Franc|FC
CHF|Swiss Franc|CHF
CLP|Chilean Peso|$
CNY|Chinese Yuan|¥
COP|Colombian Peso|$
CRC|Costa Rican Colón|₡
CUP|Cuban Peso|₱
CVE|Cape Verdean Escudo|$
CZK|Czech Koruna|Kč
DJF|Djiboutian Franc|Fdj
DKK|Danish Krone|kr
DOP|Dominican Peso|RD$
DZD|Algerian Dinar|DA
EGP|Egyptian Pound|E£
ERN|Eritrean Nakfa|Nfk
ETB|Ethiopian Birr|Br
EUR|Euro|€
FJD|Fijian Dollar|FJ$
FKP|Falkland Islands Pound|£
GBP|British Pound Sterling|£
GEL|Georgian Lari|₾
GHS|Ghanaian Cedi|GH₵
GIP|Gibraltar Pound|£
GMD|Gambian Dalasi|D
GNF|Guinean Franc|FG
GTQ|Guatemalan Quetzal|Q
GYD|Guyanese Dollar|G$
HKD|Hong Kong Dollar|HK$
HNL|Honduran Lempira|L
HTG|Haitian Gourde|G
HUF|Hungarian Forint|Ft
IDR|Indonesian Rupiah|Rp
ILS|Israeli New Shekel|₪
INR|Indian Rupee|₹
IQD|Iraqi Dinar|IQD
IRR|Iranian Rial|﷼
ISK|Icelandic Króna|kr
JMD|Jamaican Dollar|J$
JOD|Jordanian Dinar|JD
JPY|Japanese Yen|¥
KES|Kenyan Shilling|KSh
KGS|Kyrgyzstani Som|с
KHR|Cambodian Riel|៛
KMF|Comorian Franc|CF
KPW|North Korean Won|₩
KRW|South Korean Won|₩
KWD|Kuwaiti Dinar|KD
KYD|Cayman Islands Dollar|CI$
KZT|Kazakhstani Tenge|₸
LAK|Laotian Kip|₭
LBP|Lebanese Pound|L£
LKR|Sri Lankan Rupee|Rs
LRD|Liberian Dollar|L$
LSL|Lesotho Loti|L
LYD|Libyan Dinar|LD
MAD|Moroccan Dirham|MAD
MDL|Moldovan Leu|L
MGA|Malagasy Ariary|Ar
MKD|Macedonian Denar|ден
MMK|Myanmar Kyat|K
MNT|Mongolian Tugrik|₮
MOP|Macanese Pataca|MOP$
MRU|Mauritanian Ouguiya|UM
MUR|Mauritian Rupee|₨
MVR|Maldivian Rufiyaa|Rf
MWK|Malawian Kwacha|MK
MXN|Mexican Peso|MX$
MYR|Malaysian Ringgit|RM
MZN|Mozambican Metical|MT
NAD|Namibian Dollar|N$
NGN|Nigerian Naira|₦
NIO|Nicaraguan Córdoba|C$
NOK|Norwegian Krone|kr
NPR|Nepalese Rupee|₨
NZD|New Zealand Dollar|NZ$
OMR|Omani Rial|OMR
PAB|Panamanian Balboa|B/.
PEN|Peruvian Sol|S/
PGK|Papua New Guinean Kina|K
PHP|Philippine Peso|₱
PKR|Pakistani Rupee|₨
PLN|Polish Złoty|zł
PYG|Paraguayan Guarani|₲
QAR|Qatari Riyal|QR
RON|Romanian Leu|lei
RSD|Serbian Dinar|din
RUB|Russian Ruble|₽
RWF|Rwandan Franc|FRw
SAR|Saudi Riyal|SR
SBD|Solomon Islands Dollar|SI$
SCR|Seychellois Rupee|₨
SDG|Sudanese Pound|SDG
SEK|Swedish Krona|kr
SGD|Singapore Dollar|S$
SHP|Saint Helena Pound|£
SLE|Sierra Leonean Leone|Le
SOS|Somali Shilling|Sh
SRD|Surinamese Dollar|Sr$
SSP|South Sudanese Pound|SSP
STN|São Tomé and Príncipe Dobra|Db
SYP|Syrian Pound|£S
SZL|Swazi Lilangeni|E
THB|Thai Baht|฿
TJS|Tajikistani Somoni|SM
TMT|Turkmenistani Manat|m
TND|Tunisian Dinar|DT
TOP|Tongan Paʻanga|T$
TRY|Turkish Lira|₺
TTD|Trinidad and Tobago Dollar|TT$
TWD|New Taiwan Dollar|NT$
TZS|Tanzanian Shilling|TSh
UAH|Ukrainian Hryvnia|₴
UGX|Ugandan Shilling|USh
USD|US Dollar|$
UYU|Uruguayan Peso|$U
UZS|Uzbekistani Som|so'm
VES|Venezuelan Bolívar|Bs.S
VND|Vietnamese Dong|₫
VUV|Vanuatu Vatu|VT
WST|Samoan Tala|WS$
XAF|Central African CFA Franc|FCFA
XCD|East Caribbean Dollar|EC$
XOF|West African CFA Franc|CFA
XPF|CFP Franc|₣
YER|Yemeni Rial|﷼
ZAR|South African Rand|R
ZMW|Zambian Kwacha|ZK
ZWL|Zimbabwean Dollar|Z$
''';

final List<Currency> currencies = _rawCurrencies
    .split('\n')
    .map((l) => l.trim())
    .where((l) => l.isNotEmpty)
    .map((l) {
  final f = l.split('|');
  return Currency(f[0], f[1], f[2]);
}).toList();

String money(double v, Currency c, {bool sign = false}) {
  final neg = v < 0;
  final parts = v.abs().toStringAsFixed(2).split('.');
  final whole = parts[0]
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  final prefix = neg ? '-' : (sign ? '+' : '');
  return '$prefix${c.symbol} $whole.${parts[1]}';
}

String dateText(int ms) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final d = DateTime.fromMillisecondsSinceEpoch(ms);
  final h = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '${d.day} ${m[d.month - 1]} ${d.year}, $h:$mi';
}

// --------------------------------------------------------------------- store

class Txn {
  final String title;
  final double amount;
  final int ts;
  final bool interest;
  Txn(this.title, this.amount, this.ts, {this.interest = false});
  Map<String, dynamic> toJson() =>
      {'t': title, 'a': amount, 'd': ts, 'i': interest};
  factory Txn.fromJson(Map<String, dynamic> j) => Txn(
        j['t'] as String,
        (j['a'] as num).toDouble(),
        j['d'] as int,
        interest: (j['i'] as bool?) ?? false,
      );
}

// Interest settings: 10% APR, credited to the account every day.
const double kApr = 0.10;
const int kMaxTxns = 400;
const int kMaxDetailedDays = 31;

/// Whole-day number (days since 1970) for a local calendar date.
int dayNumber(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;

/// Local midnight timestamp (ms) for a day number.
int midnightOf(int dayNum) {
  final u = DateTime.fromMillisecondsSinceEpoch(dayNum * 86400000, isUtc: true);
  return DateTime(u.year, u.month, u.day).millisecondsSinceEpoch;
}

double round2(double v) => double.parse(v.toStringAsFixed(2));

class Store {
  late SharedPreferences p;
  String bank = 'ABD Bank';
  String holder = '';
  String account = '';
  String cur = 'LKR';
  double balance = 0;
  bool hide = false;
  List<Txn> txns = [];
  int lastInt = 0; // last day number interest was credited for
  double carry = 0; // fractions of a cent not yet credited
  double totalInterest = 0;

  Currency get currency =>
      currencies.firstWhere((c) => c.code == cur, orElse: () => currencies.first);

  Future<void> load() async {
    p = await SharedPreferences.getInstance();
    bank = p.getString('bank') ?? bank;
    holder = p.getString('holder') ?? '';
    account = p.getString('account') ?? '';
    cur = p.getString('cur') ?? 'LKR';
    balance = p.getDouble('balance') ?? 0;
    hide = p.getBool('hide') ?? false;
    lastInt = p.getInt('lastInt') ?? 0;
    carry = p.getDouble('carry') ?? 0;
    totalInterest = p.getDouble('totalInt') ?? 0;
    final raw = p.getString('txns');
    if (raw != null) {
      txns = (jsonDecode(raw) as List)
          .map((e) => Txn.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
  }

  Future<void> save() async {
    await p.setString('bank', bank);
    await p.setString('holder', holder);
    await p.setString('account', account);
    await p.setString('cur', cur);
    await p.setDouble('balance', balance);
    await p.setBool('hide', hide);
    await p.setInt('lastInt', lastInt);
    await p.setDouble('carry', carry);
    await p.setDouble('totalInt', totalInterest);
    await p.setString('txns', jsonEncode(txns.map((e) => e.toJson()).toList()));
  }

  Future<void> reset() async {
    await p.clear();
    bank = 'ABD Bank';
    holder = '';
    account = '';
    cur = 'LKR';
    balance = 0;
    hide = false;
    txns = [];
    lastInt = 0;
    carry = 0;
    totalInterest = 0;
  }

  /// Credits daily interest (APR / 365, compounded daily) for every calendar
  /// day that has passed since the last credit. Catches up if the app was
  /// closed for several days. Returns true if anything changed.
  Future<bool> applyInterest() async {
    if (holder.isEmpty) return false;
    final today = dayNumber(DateTime.now());
    if (lastInt == 0) {
      // Existing account from an older version: start earning from today.
      lastInt = today;
      await save();
      return false;
    }
    var days = today - lastInt;
    if (days <= 0) return false; // already credited today (or clock moved back)
    if (days > 3650) days = 3650;
    final firstDay = today - days + 1;

    const rate = kApr / 365;
    final credits = <MapEntry<int, double>>[];
    for (var i = 0; i < days; i++) {
      final total = carry + (balance + carry) * rate;
      var credit = (total * 100).floorToDouble() / 100;
      if (balance + credit >= 1e15) credit = 0;
      carry = total - credit;
      if (credit > 0) {
        balance = round2(balance + credit);
        totalInterest = round2(totalInterest + credit);
        credits.add(MapEntry(firstDay + i, credit));
      }
    }
    lastInt = today;

    // Oldest first, so inserting at index 0 keeps the list newest-first.
    final entries = <Txn>[];
    if (credits.length > kMaxDetailedDays) {
      final cut = credits.length - kMaxDetailedDays;
      final old = credits.sublist(0, cut);
      final sum = round2(old.fold<double>(0, (a, e) => a + e.value));
      entries.add(Txn('Interest (${old.length} days)', sum,
          midnightOf(old.last.key),
          interest: true));
      for (final e in credits.sublist(cut)) {
        entries.add(
            Txn('Daily interest', e.value, midnightOf(e.key), interest: true));
      }
    } else {
      for (final e in credits) {
        entries.add(
            Txn('Daily interest', e.value, midnightOf(e.key), interest: true));
      }
    }
    for (final t in entries) {
      txns.insert(0, t);
    }
    while (txns.length > kMaxTxns) {
      txns.removeLast();
    }
    await save();
    return true;
  }
}

// ----------------------------------------------------------------------- app

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ABD Bank',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F8FD0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F9FE),
      ),
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  final Store s = Store();
  bool ready = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    s.load().then((_) async {
      await s.applyInterest();
      if (mounted) setState(() => ready = true);
    });
    // Catches the midnight rollover while the app stays open.
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _interest());
  }

  Future<void> _interest() async {
    if (!ready) return;
    if (await s.applyInterest() && mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _interest();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (s.holder.isEmpty) {
      return SetupPage(s: s, onDone: () => setState(() {}));
    }
    return HomePage(s: s, onReset: () => setState(() {}));
  }
}

// ------------------------------------------------------------ currency picker

Future<Currency?> pickCurrency(BuildContext context) {
  return showModalBottomSheet<Currency>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      String q = '';
      return StatefulBuilder(builder: (ctx, set) {
        final list = currencies
            .where((c) =>
                c.code.toLowerCase().contains(q.toLowerCase()) ||
                c.name.toLowerCase().contains(q.toLowerCase()))
            .toList();
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search currency',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => set(() => q = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(
                      child: Text(list[i].symbol,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    ),
                    title: Text(list[i].code),
                    subtitle: Text(list[i].name),
                    onTap: () => Navigator.pop(ctx, list[i]),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

// --------------------------------------------------------------------- setup

class SetupPage extends StatefulWidget {
  final Store s;
  final VoidCallback onDone;
  const SetupPage({super.key, required this.s, required this.onDone});
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final nameC = TextEditingController();
  final bankC = TextEditingController(text: 'ABD Bank');
  final openC = TextEditingController();
  Currency cur = currencies.firstWhere((c) => c.code == 'LKR');
  String? err;

  Future<void> _create() async {
    final name = nameC.text.trim();
    if (name.isEmpty) {
      setState(() => err = 'Please enter your name');
      return;
    }
    final s = widget.s;
    final rnd = Random();
    s.holder = name;
    s.bank = bankC.text.trim().isEmpty ? 'ABD Bank' : bankC.text.trim();
    s.cur = cur.code;
    s.account = List.generate(12, (_) => rnd.nextInt(10)).join();
    s.balance = 0;
    s.txns = [];
    s.lastInt = dayNumber(DateTime.now()); // interest starts tomorrow
    s.carry = 0;
    s.totalInterest = 0;
    final open = double.tryParse(openC.text.replaceAll(',', '').trim());
    if (open != null && open > 0 && open < 1e15) {
      s.balance = open;
      s.txns.add(Txn('Opening deposit', open, DateTime.now().millisecondsSinceEpoch));
    }
    await s.save();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.account_balance, size: 56),
            const SizedBox(height: 16),
            const Text('Open your account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Set up your savings account in a few seconds.'),
            const SizedBox(height: 24),
            TextField(
              controller: nameC,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Account holder name',
                errorText: err,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bankC,
              decoration: const InputDecoration(
                labelText: 'Bank name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final c = await pickCurrency(context);
                if (c != null) setState(() => cur = c);
              },
              icon: const Icon(Icons.currency_exchange),
              label: Text('${cur.code} - ${cur.name}'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: openC,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Opening deposit (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _create,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Open my account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------- home

class HomePage extends StatefulWidget {
  final Store s;
  final VoidCallback onReset;
  const HomePage({super.key, required this.s, required this.onReset});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Store get s => widget.s;

  Future<void> _tx(bool deposit) async {
    final amtC = TextEditingController();
    final noteC = TextEditingController();
    String? err;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text(deposit ? 'Deposit' : 'Withdraw'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amtC,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (${s.currency.code})',
                  errorText: err,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteC,
                decoration: InputDecoration(
                  labelText: deposit
                      ? 'Source (e.g. Salary, Business)'
                      : 'Reason (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final v = double.tryParse(amtC.text.replaceAll(',', '').trim());
                if (v == null || v <= 0) {
                  set(() => err = 'Enter a valid amount');
                  return;
                }
                if (v >= 1e15 || (deposit && s.balance + v >= 1e15)) {
                  set(() => err = 'Amount is too large');
                  return;
                }
                if (!deposit && v > s.balance) {
                  set(() => err = 'Insufficient funds');
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: Text(deposit ? 'Deposit' : 'Withdraw'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final v = double.parse(amtC.text.replaceAll(',', '').trim());
    final note = noteC.text.trim();
    final delta = deposit ? v : -v;
    setState(() {
      s.balance = double.parse((s.balance + delta).toStringAsFixed(2));
      s.txns.insert(
        0,
        Txn(note.isEmpty ? (deposit ? 'Deposit' : 'Withdrawal') : note, delta,
            DateTime.now().millisecondsSinceEpoch),
      );
      if (s.txns.length > kMaxTxns) s.txns.removeLast();
    });
    await s.save();
  }

  Future<void> _menu(String v) async {
    if (v == 'cur') {
      final c = await pickCurrency(context);
      if (c != null) {
        setState(() => s.cur = c.code);
        await s.save();
      }
    } else if (v == 'bank') {
      final c = TextEditingController(text: s.bank);
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Bank name'),
          content: TextField(controller: c, autofocus: true),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Save')),
          ],
        ),
      );
      if (ok == true && c.text.trim().isNotEmpty) {
        setState(() => s.bank = c.text.trim());
        await s.save();
      }
    } else if (v == 'reset') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Close account?'),
          content: const Text(
              'This clears your balance and history and takes you back to setup.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Close account')),
          ],
        ),
      );
      if (ok == true) {
        await s.reset();
        widget.onReset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = s.currency;
    final last4 = s.account.length >= 4
        ? s.account.substring(s.account.length - 4)
        : s.account;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(s.bank),
        actions: [
          PopupMenuButton<String>(
            onSelected: _menu,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'cur', child: Text('Change currency')),
              PopupMenuItem(value: 'bank', child: Text('Rename bank')),
              PopupMenuItem(value: 'reset', child: Text('Close account')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3F2FC), Color(0xFFB5DBF5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F2F8FD0),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(s.bank,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    const Text('SAVINGS',
                        style: TextStyle(fontSize: 12, letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Available balance',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.hide ? '${c.symbol} ••••••' : money(s.balance, c),
                          style: const TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                          s.hide ? Icons.visibility_off : Icons.visibility),
                      onPressed: () async {
                        setState(() => s.hide = !s.hide);
                        await s.save();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(s.holder.toUpperCase(),
                          style: const TextStyle(letterSpacing: 1.5),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text('•••• $last4',
                        style: const TextStyle(letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Currency: ${c.code}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12)),
                    const Spacer(),
                    const Icon(Icons.trending_up,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                        '${(kApr * 100).toStringAsFixed(0)}% APR \u00b7 paid daily',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                    s.hide
                        ? 'Interest earned: ${c.symbol} ••••'
                        : 'Interest earned: ${money(s.totalInterest, c)}',
                    style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _tx(true),
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Deposit'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _tx(false),
                  icon: const Icon(Icons.arrow_upward),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Withdraw'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Recent activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (s.txns.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No transactions yet')),
            ),
          ...s.txns.map((t) {
            final pos = t.amount >= 0;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: t.interest
                    ? Colors.blue.shade100
                    : (pos ? Colors.green.shade100 : Colors.red.shade100),
                child: Icon(
                    t.interest
                        ? Icons.savings
                        : (pos ? Icons.arrow_downward : Icons.arrow_upward),
                    size: 18,
                    color: t.interest
                        ? Colors.blue.shade800
                        : (pos ? Colors.green.shade800 : Colors.red.shade800)),
              ),
              title: Text(t.title),
              subtitle: Text(dateText(t.ts)),
              trailing: Text(
                s.hide ? '••••' : money(t.amount, c, sign: true),
                style: TextStyle(
                  color: pos ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
