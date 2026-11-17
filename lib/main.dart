import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'dart:convert';
import 'local_database.dart';

void main() => runApp(const AliMuizApp());

const navy = Color(0xFF102A43);
const blue = Color(0xFF1769AA);
const teal = Color(0xFF2A9D8F);
const correctGreen = Color(0xFF218838);
const wrongRed = Color(0xFFD62828);

const units = [
  ('Health','الصحة',Icons.health_and_safety),
  ('Law','القانون',Icons.gavel),
  ('Careers','المهن',Icons.work),
  ('Unit Four','الوحدة الرابعة',Icons.menu_book),
  ('Tourism','السياحة',Icons.travel_explore),
  ('Business','الأعمال',Icons.business_center),
  ('Learning','التعلّم',Icons.school),
  ('Nature','الطبيعة',Icons.nature),
];

class AliMuizApp extends StatelessWidget {
  const AliMuizApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false,
    title:"Ali moez",
    theme:ThemeData(
      useMaterial3:true,
      colorScheme:ColorScheme.fromSeed(seedColor:blue),
      scaffoldBackgroundColor:const Color(0xFFF3F7FA),
      appBarTheme:const AppBarTheme(backgroundColor:navy,foregroundColor:Colors.white),
    ),
    home:const MainScreen(),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState()=>_MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int tab=0;
  @override Widget build(BuildContext context) {
    final pages=[const HomePage(),const UnitsPage(),const LiteraturePage(),const ProgressPage()];
    final labels=['Home','Course Units','Literature','My Progress'];
    return Scaffold(
      appBar:AppBar(title:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(labels[tab],style:const TextStyle(fontWeight:FontWeight.bold)),
        const Text("Ali moez",style:TextStyle(fontSize:12,letterSpacing:1.2))
      ])),
      body:pages[tab],
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
        NavigationDestination(icon:Icon(Icons.home_outlined),label:'Home'),
        NavigationDestination(icon:Icon(Icons.menu_book_outlined),label:'Units'),
        NavigationDestination(icon:Icon(Icons.auto_stories_outlined),label:'Literature'),
        NavigationDestination(icon:Icon(Icons.insights_outlined),label:'Progress'),
      ]),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[
    Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(gradient:const LinearGradient(colors:[navy,blue]),borderRadius:BorderRadius.circular(22)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Welcome back!',style:TextStyle(color:Colors.white70)),
      SizedBox(height:8),Text('Learn English\nStep by Step',style:TextStyle(color:Colors.white,fontSize:28,fontWeight:FontWeight.bold)),
      SizedBox(height:8),Text('Your learning journey starts here.',style:TextStyle(color:Colors.white70))
    ])),
    const SizedBox(height:22),const Heading('Explore','استكشف'),
    Wrap(spacing:10,runSpacing:10,children:[
      const Feature('Vocabulary','المفردات',Icons.translate,blue),
      const Feature('Grammar','القواعد',Icons.rule,teal),
      const Feature('Reading','القطع الخارجية',Icons.chrome_reader_mode,Color(0xFF805AD5)),
      InkWell(borderRadius:BorderRadius.circular(16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ActivityBookPage())),child:const Feature('Activity Book','كتاب النشاط',Icons.menu_book,Color(0xFF0F8B8D))),
    ]),
    const SizedBox(height:14),
    Card(child:ListTile(
      leading:const CircleAvatar(child:Icon(Icons.picture_as_pdf,color:blue)),
      title:const Text('Official Study Materials',style:TextStyle(fontWeight:FontWeight.bold)),
      subtitle:const Text('الملزمتان الأصليتان للوحدات 1–8'),
      trailing:const Icon(Icons.chevron_right),
      onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const StudyMaterialsPage())),
    )),
    const SizedBox(height:22),const Heading('Course Units','الوحدات الدراسية'),
    ...List.generate(3,(i)=>UnitCard(index:i)),
    const SizedBox(height:8),
  ]);
}
class Heading extends StatelessWidget {
 final String en,ar; const Heading(this.en,this.ar,{super.key});
 @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:10),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
  Text(en,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:navy)),Text(ar,style:const TextStyle(color:Colors.black54))
 ]));
}
class Feature extends StatelessWidget {
 final String en,ar; final IconData icon; final Color color;
 const Feature(this.en,this.ar,this.icon,this.color,{super.key});
 @override Widget build(BuildContext context)=>SizedBox(width:MediaQuery.sizeOf(context).width/2-24,child:Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Icon(icon,color:color,size:28),const SizedBox(height:10),Text(en,style:const TextStyle(fontWeight:FontWeight.bold)),Text(ar,style:const TextStyle(color:Colors.black54,fontSize:12))
 ]))));
}
class UnitsPage extends StatelessWidget {
 const UnitsPage({super.key});
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(18),children:[
  const Text('Choose your unit',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold,color:navy)),
  const Text('اختر الوحدة الدراسية',style:TextStyle(color:Colors.black54)),const SizedBox(height:15),
  ...List.generate(8,(i)=>UnitCard(index:i))
 ]);
}
class UnitCard extends StatelessWidget {
 final int index; const UnitCard({required this.index,super.key});
 @override Widget build(BuildContext context){
  final u=units[index];
  return Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(
   leading:CircleAvatar(backgroundColor:const Color(0xFFE7F0F8),child:Icon(u.$3,color:blue)),
   title:Text('Unit ${index+1} – ${u.$1}',style:const TextStyle(fontWeight:FontWeight.bold)),
   subtitle:Text(u.$2),trailing:const Icon(Icons.chevron_right),
   onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>UnitDetail(index:index)))
  ));
 }
}
class UnitDetail extends StatelessWidget {
 final int index; const UnitDetail({required this.index,super.key});
 @override Widget build(BuildContext context){final u=units[index];return Scaffold(appBar:AppBar(title:Text('Unit ${index+1} – ${u.$1}')),body:ListView(padding:const EdgeInsets.all(18),children:[
  Text(u.$2,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:navy)),
  const SizedBox(height:10),
  Card(child:ListTile(
    leading:const Icon(Icons.picture_as_pdf,color:wrongRed),
    title:const Text('Open unit study booklet'),
    subtitle:Text(index<4?'Book 1–4 • الكتاب الأول':'Book 5–8 • الكتاب الثاني'),
    trailing:const Icon(Icons.open_in_new),
    onTap:()=>openStudyPdf(context,index<4?0:1),
  )),
  if(index==0) Card(child:ListTile(
    leading:const CircleAvatar(backgroundColor:Color(0xFFE1F3EF),child:Icon(Icons.fact_check,color:teal)),
    title:const Text('Verified Unit 1 Practice',style:TextStyle(fontWeight:FontWeight.bold)),
    subtitle:const Text('تمارين الوحدة الأولى المدققة من الملزمة'),
    trailing:const Icon(Icons.chevron_right),
    onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const UnitOnePracticePage())),
  )),
  if(index==0) Card(child:ListTile(
    leading:const CircleAvatar(backgroundColor:Color(0xFFE7F0F8),child:Icon(Icons.library_books,color:blue)),
    title:const Text('Complete Unit 1 Activity Book',style:TextStyle(fontWeight:FontWeight.bold)),
    subtitle:const Text('جميع مقاطع تمارين الوحدة الأولى مرتبة حسب الصفحة والتمرين'),
    trailing:const Icon(Icons.chevron_right),
    onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ActivityBookPage(initialUnit:1))),
  )),
  if(index==0) Card(child:ListTile(
    leading:const CircleAvatar(backgroundColor:Color(0xFFE7F0F8),child:Icon(Icons.history_edu,color:blue)),
    title:const Text('Lesson 2 • Past Tenses Practice',style:TextStyle(fontWeight:FontWeight.bold)),
    subtitle:const Text('التمرين 7/B و7/C من الصفحات 8–9'),
    trailing:const Icon(Icons.chevron_right),
    onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const LessonTwoPracticePage())),
  )),
  ...['Target Vocabulary','Lessons','Grammar','Reading','Activity Book Exercises'].map((s)=>Card(child:ListTile(
    title:Text(s),trailing:const Icon(Icons.chevron_right),
    onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ActivityBookPage(initialUnit:index+1)))
  )))
 ]));}
}
class StudyMaterialsPage extends StatelessWidget {
 const StudyMaterialsPage({super.key});
 @override Widget build(BuildContext context)=>Scaffold(
  appBar:AppBar(title:const Text('Study Materials')),
  body:ListView(padding:const EdgeInsets.all(18),children:[
   const Text('Curriculum Booklets',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy)),
   const Text('المواد الدراسية الأصلية المرفقة بالتطبيق',style:TextStyle(color:Colors.black54)),
   const SizedBox(height:14),
   Card(child:ListTile(leading:const Icon(Icons.picture_as_pdf,color:wrongRed,size:34),title:const Text('Units 1–4'),subtitle:const Text('Health • Law • Careers • Unit Four'),trailing:const Icon(Icons.open_in_new),onTap:()=>openStudyPdf(context,0))),
   Card(child:ListTile(leading:const Icon(Icons.picture_as_pdf,color:wrongRed,size:34),title:const Text('Units 5–8'),subtitle:const Text('Tourism • Business • Learning • Nature'),trailing:const Icon(Icons.open_in_new),onTap:()=>openStudyPdf(context,1))),
   const SizedBox(height:12),
   const Card(child:Padding(padding:EdgeInsets.all(14),child:Text('ملاحظة: هذه هي ملفات المادة الأصلية بصيغة PDF. يفتحها التطبيق باستخدام قارئ PDF الموجود على جهازك، ويمكنك الرجوع إليها أثناء الدراسة وحل التمارين.'))),
  ])
 );
}

Future<void> openStudyPdf(BuildContext context,int book) async {
 final asset=book==0?'assets/materials/units_1_4.pdf':'assets/materials/units_5_8.pdf';
 final filename=book==0?'ALI_MUIZ_Units_1_4.pdf':'ALI_MUIZ_Units_5_8.pdf';
 try {
  final bytes=await rootBundle.load(asset);
  final dir=await getApplicationDocumentsDirectory();
  final file=File('${dir.path}/$filename');
  await file.writeAsBytes(bytes.buffer.asUint8List(),flush:true);
  final result=await OpenFilex.open(file.path);
  if(result.type!=ResultType.done && context.mounted){
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تعذّر فتح PDF. تأكد من وجود قارئ PDF على الجهاز.')));
  }
 } catch(e) {
  if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('حدث خطأ عند فتح المادة: $e')));
 }
}

class LiteraturePage extends StatelessWidget {
 const LiteraturePage({super.key});
 @override Widget build(BuildContext context)=>const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[
  Icon(Icons.auto_stories,size:58,color:blue),SizedBox(height:12),Text('Literature',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:navy)),Text('الأدب')
 ]));
}
class ProgressPage extends StatefulWidget {
 const ProgressPage({super.key});
 @override State<ProgressPage> createState()=>_ProgressPageState();
}
class _ProgressPageState extends State<ProgressPage> {
 late Future<List<Map<String,Object?>>> results;
 late Future<Map<String,Object?>> summary;
 void reload(){results=LocalDatabase.instance.getResults();summary=LocalDatabase.instance.getSummary();}
 @override void initState(){super.initState();reload();}
 @override Widget build(BuildContext context)=>RefreshIndicator(
  onRefresh:()async{setState(reload);await results;},
  child:ListView(padding:const EdgeInsets.all(18),children:[
   const Text('My Progress',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold,color:navy)),
   const Text('تقدّم الطالب',style:TextStyle(color:Colors.black54)),
   const SizedBox(height:15),
   FutureBuilder<Map<String,Object?>>(future:summary,builder:(context,snapshot){
    final d=snapshot.data??{'attempts':0,'earned':0,'possible':0};
    return Row(children:[
     Expanded(child:StatCard('Attempts','${d['attempts']??0}',Icons.assignment_turned_in)),
     const SizedBox(width:10),
     Expanded(child:StatCard('Points','${d['earned']??0}/${d['possible']??0}',Icons.stars)),
    ]);
   }),
   const SizedBox(height:20),
   const Text('Recent Results',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:navy)),
   const SizedBox(height:8),
   FutureBuilder<List<Map<String,Object?>>>(future:results,builder:(context,snapshot){
    if(snapshot.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
    final rows=snapshot.data??[];
    if(rows.isEmpty)return const Card(child:Padding(padding:EdgeInsets.all(18),child:Text('No results yet. Complete a practice quiz to see your scores here.\\nلا توجد نتائج بعد. أكمل اختباراً تجريبياً لعرض درجاتك.')));
    return Column(children:rows.map((r)=>Card(child:ListTile(
     leading:const CircleAvatar(child:Icon(Icons.quiz)),
     title:Text('${r['quiz_name']}'),
     subtitle:Text('${r['completed_at']}'),
     trailing:Text('${r['score']} / ${r['total']}',style:const TextStyle(fontWeight:FontWeight.bold,color:teal)),
    ))).toList());
   }),
  ])
 );
}
class StatCard extends StatelessWidget {
 final String title,value; final IconData icon;
 const StatCard(this.title,this.value,this.icon,{super.key});
 @override Widget build(BuildContext context)=>Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(children:[
  Icon(icon,color:teal,size:28),const SizedBox(height:6),
  Text(value,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:navy)),
  Text(title,style:const TextStyle(color:Colors.black54))
 ])));
}



class _BilingualStatement extends StatelessWidget {
 final String letter,english,arabic;
 const _BilingualStatement(this.letter,this.english,this.arabic);
 @override Widget build(BuildContext context)=>Padding(
  padding:const EdgeInsets.symmetric(horizontal:12,vertical:9),
  child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
   CircleAvatar(radius:15,backgroundColor:const Color(0xFFE5EFF8),child:Text(letter,style:const TextStyle(color:navy,fontWeight:FontWeight.bold))),
   const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    Text(english,style:const TextStyle(fontSize:15,height:1.45)),
    const SizedBox(height:3),Text(arabic,textDirection:TextDirection.rtl,style:const TextStyle(fontSize:14,height:1.45,color:Colors.black54)),
   ])),
  ]),
 );
}

// Unit 1 content transcribed and visually checked against the supplied 2027 booklet,
// PDF pages 2–4 (printed pages 2–4). Only source-provided answers are marked.
class UnitOnePracticePage extends StatefulWidget {
 const UnitOnePracticePage({super.key});
 @override State<UnitOnePracticePage> createState()=>_UnitOnePracticePageState();
}
class _UnitOnePracticePageState extends State<UnitOnePracticePage> {
 final Map<int,String> answers={};
 bool submitted=false;
 bool saved=false;
 static const words=['Bleeding','broken','hurt','pain','sick','sore','dizzy','sneeze'];
 static const questions=[
  ('"Have you got a cold?" "No, I always _____ when I put pepper on my food"','"هل أصبت بنزلة برد؟" "لا، أنا دائماً أعطس عندما أضع الفلفل على طعامي."','sneeze'),
  ("He was _____ three times in the night. I think the food at the restaurant where he ate wasn't very fresh.",'كان قد تقيأ ثلاث مرات في الليل. أعتقد أن الطعام في المطعم الذي أكل فيه لم يكن طازجاً جداً.','sick'),
  ('She cut her hand while she was chopping vegetables. It was a very deep cut, and it was _____ a lot, so she had to go to hospital and have it stitched.','جرحت يدها أثناء تقطيع الخضروات. كان الجرح عميقاً جداً وكان ينزف كثيراً، لذا كان عليها الذهاب إلى المستشفى وخياطته.','bleeding'),
  ('My back _____ all the time. It only feels OK when I am lying down.','ظهري يؤلمني طوال الوقت. أشعر بالراحة فقط عندما أكون مستلقياً.','hurt'),
  ("She can’t play tennis. She has _____ her right arm.",'لا تستطيع لعب التنس. لقد كسرت ذراعها اليمنى.','broken'),
  ('I went swimming yesterday and now my eyes are _____ from the chemicals in the pool.','ذهبت للسباحة أمس والآن عيناي تؤلمني بسبب المواد الكيميائية في المسبح.','sore'),
  ('Where exactly is the _____ and how long have you had it?','أين بالضبط الألم وكم من الوقت مضى عليك؟','pain'),
  ('It was a very hot day, and she hadn’t eaten or drunk anything all day. That’s why she suddenly went pale and felt _____ during the lesson.','كان يوماً حاراً جداً ولم تأكل أو تشرب أي شيء طوال اليوم. لهذا السبب شحبت فجأة وشعرت بالدوار أثناء الدرس.','dizzy'),
 ];
 int get score=>List.generate(questions.length,(i)=>answers[i]==questions[i].$3).where((v)=>v).length;
 @override Widget build(BuildContext context)=>Scaffold(
  appBar:AppBar(title:const Text('Ali moez • Unit 1')),
  body:ListView(padding:const EdgeInsets.all(16),children:[
   const Text('Lesson 1 – My toe is bleeding',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy)),
   const Text('التمارين المعتمدة من صفحات الملزمة 2–4',style:TextStyle(color:Colors.black54)),
   const SizedBox(height:14),
   const Text('Lesson 1 • Match the statements',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold,color:navy)),
   const Text('طابق ما يقوله كل شخص بالصورة الصحيحة — الحروف كما وردت في الملزمة',style:TextStyle(fontSize:15)),
   const SizedBox(height:8),
   Card(child:Column(children:const [
    _BilingualStatement('i','My shoulder hurts. I did it playing tennis.','كتفي يؤلمني بسبب لعب التنس.'),
    _BilingualStatement('H','I burnt my finger on the oven.','أحرقت إصبعي في الفرن.'),
    _BilingualStatement('E',"I’ve got a broken leg. I fractured it in a motorbike accident.",'ساقي مكسورة، كسرتها في حادث دراجة.'),
    _BilingualStatement('J','I feel dizzy. I need to lie down.','أشعر بالدوار. أحتاج إلى الاستلقاء.'),
    _BilingualStatement('D',"I’ve got a pain in my knee. It’s really swollen.",'أشعر بألم في ركبتي، إنها حقاً متورمة.'),
    _BilingualStatement('G',"I’ve got a terrible headache. Can I have some painkillers?",'لدي صداع مزعج. هل بالإمكان تناول بعض المسكنات؟'),
    _BilingualStatement('N',"I’ve got a sore throat. It hurts so much that I can’t swallow.",'لدي التهاب في الحنجرة، يؤلمني جداً ولا يمكنني البلع.'),
    _BilingualStatement('F','I have a temperature of 39.','حرارتي مرتفعة.'),
    _BilingualStatement('A',"I have a very bad cold. I can’t stop sneezing.",'أصبت ببرد شديد ولا يمكنني التوقف عن العطس.'),
    _BilingualStatement('L',"I need this bucket because I think I’m going to be sick.",'أنا بحاجة لهذا الدلو. أعتقد بأنني سوف أتقيأ.'),
    _BilingualStatement('B',"I’ve got a bad wrist. I sprained it lifting weights in the gym.",'معصمي بحالة سيئة. لقد التوى عند رفع الأثقال في القاعة الرياضية.'),
    _BilingualStatement('K','I twisted my ankle playing football.','ثنيت كاحلي أثناء لعب كرة القدم.'),
    _BilingualStatement('C','My toe is bleeding. I cut it on a piece of glass on the beach.','إصبع قدمي ينزف. جرحته بقطعة من الزجاج عند الشاطئ.'),
    _BilingualStatement('M','My lips are really dry and sore.','شفتاي جافتان ومتقرحتان.'),
   ])),
   const SizedBox(height:18),
   const Text('4/A • Set / Words',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold,color:navy)),
   const Text('اكتب الكلمات الآتية في المجموعة الصحيحة',style:TextStyle(fontSize:16)),
   const SizedBox(height:8),
   Card(child:SingleChildScrollView(scrollDirection:Axis.horizontal,child:DataTable(
    headingRowColor:WidgetStateProperty.all(const Color(0xFFE4EFF8)),
    columns:const [DataColumn(label:Text('Set / المجموعة')),DataColumn(label:Text('Words / الكلمات'))],
    rows:const [
     DataRow(cells:[DataCell(Text('Treatment\nمعالجة، علاج')),DataCell(Text('bandage • cream • medicine • plaster • pills\nضماد • مرهم • علاج • لصقة • حبوب'))]),
     DataRow(cells:[DataCell(Text('Joints\nمفاصل')),DataCell(Text('ankle • elbow • knee • shoulder • wrist\nكاحل • مرفق • ركبة • كتف • معصم، رسغ'))]),
     DataRow(cells:[DataCell(Text('Verbs\nأفعال')),DataCell(Text('breathe • cough • faint • sneeze • swallow\nيتنفس • يسعل • يغمى عليه • يعطس • يبلع'))]),
     DataRow(cells:[DataCell(Text('Inside and outside the body\nداخل وخارج الجسم')),DataCell(Text('blood • bones • heart • skin • stomach\nدم • عظام • قلب • جلد • معدة'))]),
    ],
   ))),
   const SizedBox(height:18),
   const Text('5/C • Complete each sentence',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold,color:navy)),
   const Text('أكمل كل جملة بكلمة من الصندوق',style:TextStyle(fontSize:16)),
   const SizedBox(height:8),
   Card(child:Padding(padding:const EdgeInsets.all(12),child:Wrap(spacing:8,runSpacing:8,children:words.map((w)=>Chip(label:Text(w,style:const TextStyle(fontWeight:FontWeight.bold)))).toList()))),
   ...List.generate(questions.length,(i){final q=questions[i];final isCorrect=answers[i]==q.$3;return Card(margin:const EdgeInsets.only(bottom:10),child:Padding(padding:const EdgeInsets.all(13),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    Text('${i+1}. ${q.$1}',style:const TextStyle(fontSize:17,height:1.5)),
    const SizedBox(height:7),
    Text(q.$2,textDirection:TextDirection.rtl,style:const TextStyle(fontSize:15,height:1.6,color:Colors.black87)),
    const SizedBox(height:8),
    DropdownButtonFormField<String>(value:answers[i],isExpanded:true,decoration:const InputDecoration(labelText:'اختر الإجابة / Choose',border:OutlineInputBorder(),isDense:true),items:words.map((w)=>DropdownMenuItem(value:w.toLowerCase(),child:Text(w))).toList(),onChanged:submitted?null:(v)=>setState(()=>answers[i]=v??'')),
    if(submitted) Padding(padding:const EdgeInsets.only(top:8),child:Row(children:[Icon(isCorrect?Icons.check_circle:Icons.cancel,color:isCorrect?correctGreen:wrongRed),const SizedBox(width:6),Expanded(child:Text(isCorrect?'إجابة صحيحة':'الإجابة الصحيحة: ${q.$3}',style:TextStyle(color:isCorrect?correctGreen:wrongRed,fontWeight:FontWeight.bold))) ])),
   ])));}),
   if(!submitted) FilledButton.icon(onPressed:answers.length==questions.length?()=>setState(()=>submitted=true):null,icon:const Icon(Icons.check),label:const Text('تصحيح الإجابات')),
   if(submitted) Card(color:const Color(0xFFE7F5EC),child:Padding(padding:const EdgeInsets.all(16),child:Column(children:[Text('النتيجة: $score / ${questions.length}',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:correctGreen)),const SizedBox(height:8),FilledButton.icon(onPressed:saved?null:()async{await LocalDatabase.instance.saveQuizResult('Unit 1 • Exercise 5/C',score,questions.length);if(!mounted)return;setState(()=>saved=true);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم حفظ نتيجتك في سجل التقدم')));},icon:const Icon(Icons.save),label:Text(saved?'تم حفظ النتيجة':'حفظ النتيجة'))]))),
   if(submitted) OutlinedButton(onPressed:()=>setState((){answers.clear();submitted=false;saved=false;}),child:const Text('إعادة المحاولة')),
  ]),
 );
}


// Lesson 2 exercises 7/B and 7/C transcribed from the supplied booklet,
// PDF pages 8–9 (printed pages 8–9). The answer key is visible in the source.
class LessonTwoPracticePage extends StatefulWidget {
 const LessonTwoPracticePage({super.key});
 @override State<LessonTwoPracticePage> createState()=>_LessonTwoPracticePageState();
}
class _LessonTwoPracticePageState extends State<LessonTwoPracticePage> {
 final Map<int,String> answers={};
 final List<TextEditingController> ownAnswers=List.generate(6,(_)=>TextEditingController());
 bool submitted=false, saved=false;
 static const data=<({String question,String arabic,List<String> options,String answer})>[
  (question:'I (think) about you and then you (ring) me.',arabic:'كنت أفكر فيك ثم اتصلت بي.',options:['was thinking / rang','thought / were ringing'],answer:'was thinking / rang'),
  (question:'While Ali (have) a shower, somebody (knock) at the door.',arabic:'بينما كان علي يستحم، طرق شخص ما الباب.',options:['was having / knocked','had / was knocking'],answer:'was having / knocked'),
  (question:'I (clean) my room and I (find) 30 under my bed.',arabic:'كنت أنظف غرفتي فوجدت 30 تحت سريري.',options:['was cleaning / found','cleaned / was finding'],answer:'was cleaning / found'),
  (question:'Luckily, Reema (not drive) very fast when the child (run) into the road.',arabic:'لحسن الحظ، لم تكن ريما تقود بسرعة كبيرة عندما ركض الطفل إلى الشارع.',options:['was not driving / ran','did not drive / was running'],answer:'was not driving / ran'),
  (question:'A thief (take) our clothes while we (swim).',arabic:'سرق لص ملابسنا بينما كنا نسبح.',options:['took / were swimming','was taking / swam'],answer:'took / were swimming'),
  (question:'She (tell) us to be quiet as we (make) too much noise.',arabic:'أخبرتنا أن نلتزم الهدوء لأننا كنا نُصدر ضجيجاً كثيراً.',options:['told / were making','was telling / made'],answer:'told / were making'),
  (question:'My sister (hide) my purse under the bed while I (not look).',arabic:'أخفت أختي محفظتي تحت السرير بينما لم أكن منتبهاً.',options:['hid / was not looking','was hiding / did not look'],answer:'hid / was not looking'),
  (question:'As she (carry) the shopping from the car, my grandmother (slip) and (break) her ankle.',arabic:'بينما كانت تحمل المشتريات من السيارة، انزلقت جدتي وكسرت كاحلها.',options:['was carrying / slipped / broke','carried / was slipping / was breaking'],answer:'was carrying / slipped / broke'),
 ];
 static const ownPrompts=<({String en,String ar,String sample})>[
  (en:'I was running, and I fell down.',ar:'كنت أركض، فسقطت على الأرض.',sample:'I fell down.'),
  (en:"I wasn’t looking where I was going, and I hit a tree.",ar:'لم أكن أنظر إلى أين أذهب، فاصطدمت بشجرة.',sample:'I hit a tree.'),
  (en:'I was getting ready for school when the power went out.',ar:'كنت أستعد للذهاب إلى المدرسة عندما انقطع التيار الكهربائي.',sample:'the power went out'),
  (en:'My little brother was playing football when he broke a window.',ar:'كان أخي الصغير يلعب كرة القدم عندما كسر النافذة.',sample:'he broke a window'),
  (en:'I was thinking about my weekend when the teacher suddenly asked me a question.',ar:'كنت أفكر في عطلة نهاية الأسبوع عندما سألني المعلم فجأة.',sample:'asked me a question'),
  (en:'While I was waiting for the bus, it started to rain.',ar:'بينما كنت أنتظر الحافلة، بدأت تمطر.',sample:'it started to rain'),
 ];
 int get score=>List.generate(data.length,(i)=>answers[i]==data[i].answer).where((v)=>v).length;
 @override void dispose(){for(final c in ownAnswers){c.dispose();}super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Ali moez • Lesson 2')),body:ListView(padding:const EdgeInsets.all(16),children:[
  const Text('Lesson 2 – I was ice-skating and I fell over',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:navy)),
  const Text('الصفحات المطبوعة 8–9 • التمرينان 7/B و7/C',style:TextStyle(color:Colors.black54)),
  const SizedBox(height:16),
  const Text('7/B • Past continuous and past simple',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold,color:navy)),
  const Text('ضع فعلاً واحداً بصيغة الماضي المستمر وفعلاً واحداً بصيغة الماضي البسيط.',style:TextStyle(fontSize:15)),
  const SizedBox(height:8),
  ...List.generate(data.length,(i){final q=data[i];final ok=answers[i]==q.answer;return Card(margin:const EdgeInsets.only(bottom:10),child:Padding(padding:const EdgeInsets.all(13),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
   Text('${i+1}. ${q.question}',style:const TextStyle(fontSize:17,height:1.5)),
   const SizedBox(height:5),Text(q.arabic,textDirection:TextDirection.rtl,style:const TextStyle(fontSize:15,height:1.5,color:Colors.black54)),
   const SizedBox(height:8),DropdownButtonFormField<String>(value:answers[i],isExpanded:true,decoration:const InputDecoration(labelText:'اختر الإجابة الصحيحة',border:OutlineInputBorder()),items:q.options.map((o)=>DropdownMenuItem(value:o,child:Text(o,style:const TextStyle(fontSize:14)))).toList(),onChanged:submitted?null:(v)=>setState(()=>answers[i]=v??'')),
   if(submitted)Padding(padding:const EdgeInsets.only(top:8),child:Text(ok?'إجابة صحيحة ✓':'الإجابة الصحيحة: ${q.answer}',style:TextStyle(color:ok?correctGreen:wrongRed,fontWeight:FontWeight.bold)))
  ])));}),
  if(!submitted)FilledButton.icon(onPressed:answers.length==data.length?()=>setState(()=>submitted=true):null,icon:const Icon(Icons.check),label:const Text('تصحيح التمرين 7/B')),
  if(submitted)Card(color:const Color(0xFFE7F5EC),child:Padding(padding:const EdgeInsets.all(14),child:Column(children:[Text('النتيجة: $score / ${data.length}',style:const TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:correctGreen)),FilledButton.icon(onPressed:saved?null:()async{await LocalDatabase.instance.saveQuizResult('Unit 1 • Lesson 2 • Exercise 7/B',score,data.length);if(!mounted)return;setState(()=>saved=true);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم حفظ النتيجة')));},icon:const Icon(Icons.save),label:Text(saved?'تم الحفظ':'حفظ النتيجة'))]))),
  if(submitted)OutlinedButton(onPressed:()=>setState((){answers.clear();submitted=false;saved=false;}),child:const Text('إعادة المحاولة')),
  const Divider(height:32),
  const Text('7/C • Complete with your own ideas',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold,color:navy)),
  const Text('أكمل الجمل بأفكارك الخاصة. استخدم الماضي البسيط للأفعال.',style:TextStyle(fontSize:15)),
  const SizedBox(height:8),
  ...List.generate(ownPrompts.length,(i){final q=ownPrompts[i];return Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[Text('${i+1}. ${q.en}',style:const TextStyle(fontSize:16,height:1.5)),const SizedBox(height:4),Text(q.ar,textDirection:TextDirection.rtl,style:const TextStyle(fontSize:14,color:Colors.black54)),const SizedBox(height:8),TextField(controller:ownAnswers[i],minLines:1,maxLines:2,decoration:const InputDecoration(labelText:'اكتب إجابتك',border:OutlineInputBorder(),isDense:true))])));}),
  const Card(color:Color(0xFFFFF4D6),child:Padding(padding:EdgeInsets.all(12),child:Text('تمرين 7/C يعتمد على أفكار الطالب؛ لذلك لا يوجد له تصحيح آلي. الجمل المعروضة وترجمتها منقولة من الصفحة 9.',style:TextStyle(color:Color(0xFF6B4E16))))),
 ]));
}

// Curriculum practice questions transcribed from the supplied booklets.
class ActivityBookPage extends StatefulWidget {
 final int? initialUnit;
 const ActivityBookPage({super.key,this.initialUnit});
 @override State<ActivityBookPage> createState()=>_ActivityBookPageState();
}
class _ActivityBookPageState extends State<ActivityBookPage> {
 late Future<Map<String,dynamic>> dataFuture;
 int selectedUnit=0;
 String query='';
 @override void initState(){super.initState();selectedUnit=widget.initialUnit??0;dataFuture=loadData();}
 Future<Map<String,dynamic>> loadData() async {
  final data=jsonDecode(await rootBundle.loadString('assets/activity_book_exercises.json')) as Map<String,dynamic>;
  data['unit1_catalog']=jsonDecode(await rootBundle.loadString('assets/unit1_activity_catalog.json')) as Map<String,dynamic>;
  return data;
 }
 @override Widget build(BuildContext context)=>Scaffold(
  appBar:AppBar(title:const Text('Activity Book • كتاب النشاط')),
  body:FutureBuilder<Map<String,dynamic>>(future:dataFuture,builder:(context,snapshot){
   if(snapshot.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
   if(snapshot.hasError)return Center(child:Text('تعذر تحميل فهرس التمارين: ${snapshot.error}'));
   final data=snapshot.data!;
   final sourceBlocks=(selectedUnit==1?(data['unit1_catalog']['blocks'] as List):(data['blocks'] as List)).cast<Map<String,dynamic>>();
   final blocks=sourceBlocks.where((b){
    final unitOk=selectedUnit==0 || b['unit']==selectedUnit;
    final hay='${b['lesson_title_as_extracted']} ${b['exercise_label']} ${b['heading_as_extracted']} ${b['source_text_block']} ${b['printed_page']}'.toLowerCase();
    return unitOk && hay.contains(query.toLowerCase());
   }).toList();
   return Column(children:[
    Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:selectedUnit==1?const Color(0xFFE7F5EC):const Color(0xFFFFF4D6),borderRadius:BorderRadius.circular(10)),child:Text(selectedUnit==1?'الوحدة الأولى: ${blocks.length} تمريناً/مقطعاً من كتاب النشاط، مرتبة حسب الصفحة وحرف التمرين. افتح أي تمرين لعرض نصه كاملاً ومساحة الإجابة. لا يظهر تصحيح آلي إلا عند توفر مفتاح موثق في المصدر.':'فهرس كتاب النشاط: ${data['total_candidate_blocks']} مقطعاً مرشحاً من الوحدات الثماني. النصوص محفوظة كما استُخرجت من المصدر، وتحتاج المقاطع غير المدققة إلى مراجعة قبل إضافة تصحيح آلي.',style:const TextStyle(fontSize:12,color:Color(0xFF345B45))),),
    Padding(padding:const EdgeInsets.fromLTRB(12,12,12,6),child:TextField(onChanged:(v)=>setState(()=>query=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'ابحث في التمارين أو الدروس أو الصفحات',border:OutlineInputBorder(),isDense:true))),
    Padding(padding:const EdgeInsets.symmetric(horizontal:12,vertical:5),child:DropdownButtonFormField<int>(value:selectedUnit,decoration:const InputDecoration(labelText:'الوحدة',border:OutlineInputBorder(),isDense:true),items:[const DropdownMenuItem(value:0,child:Text('كل الوحدات')), ...List.generate(8,(i)=>DropdownMenuItem(value:i+1,child:Text('Unit ${i+1}')))],onChanged:(v)=>setState(()=>selectedUnit=v??0))),
    Padding(padding:const EdgeInsets.all(10),child:Align(alignment:Alignment.centerLeft,child:Text('${blocks.length} مقطعاً',style:const TextStyle(fontWeight:FontWeight.bold,color:navy)))),
    Expanded(child:blocks.isEmpty?const Center(child:Text('لا توجد نتائج مطابقة')):ListView.builder(padding:const EdgeInsets.symmetric(horizontal:12),itemCount:blocks.length,itemBuilder:(context,i){
     final b=blocks[i];
     return Card(margin:const EdgeInsets.only(bottom:10),child:ExpansionTile(
      leading:CircleAvatar(backgroundColor:const Color(0xFFE7F0F8),child:Text('${b['exercise_label']??'–'}',style:const TextStyle(color:navy,fontWeight:FontWeight.bold))),
      title:Text('${(b['lesson_title_as_extracted']??'').toString().trim().isEmpty?'Activity Book Exercise':'${b['lesson_title_as_extracted']}'} • ${b['exercise_label']??'–'}',style:const TextStyle(fontWeight:FontWeight.bold)),
      subtitle:Text('Unit ${b['unit']??'؟'} • الصفحة المطبوعة ${b['printed_page']??'؟'} • صفحة PDF ${b['pdf_page']??'؟'}'),
      children:[
       Padding(padding:const EdgeInsets.fromLTRB(16,0,16,16),child:SelectableText('${b['source_text_block']??b['heading_as_extracted']??''}',textDirection:TextDirection.ltr,style:const TextStyle(fontSize:17,height:1.65))),
       Padding(padding:const EdgeInsets.fromLTRB(16,0,16,8),child:Text('حالة المطابقة: ${b['pdf_audit_status']??'تحتاج مراجعة'} • المقطع يحتاج تدقيقاً بصرياً قبل تحويله إلى سؤال مصحح آلياً.',style:const TextStyle(fontSize:11,color:Colors.deepOrange))),
       Padding(padding:const EdgeInsets.fromLTRB(16,0,16,14),child:OutlinedButton.icon(
        onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ActivityExerciseDetailPage(block:b))),
        icon:const Icon(Icons.open_in_full),label:const Text('فتح التمرين بحجم كامل • Open exercise')))
      ]));
    }))
   ]);
  })
 );
}


// Full-screen reading view for a source exercise. It preserves the extracted wording;
// no answer key or automatic marking is invented for unaudited source blocks.
class ActivityExerciseDetailPage extends StatefulWidget {
 final Map<String,dynamic> block;
 const ActivityExerciseDetailPage({super.key,required this.block});
 @override State<ActivityExerciseDetailPage> createState()=>_ActivityExerciseDetailPageState();
}
class _ActivityExerciseDetailPageState extends State<ActivityExerciseDetailPage> {
 final answerController=TextEditingController();
 @override void dispose(){answerController.dispose();super.dispose();}
 List<String> get lines => ('${widget.block['source_text_block']??widget.block['heading_as_extracted']??''}')
   .split(RegExp(r'\r?\n')).map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList();
 bool get looksLikeSetWords => lines.any((e)=>e.toLowerCase().contains('set')) && lines.any((e)=>e.toLowerCase().contains('words'));
 @override Widget build(BuildContext context){
  final b=widget.block;
  return Scaffold(appBar:AppBar(title:Text('Unit ${b['unit']} • Exercise ${b['exercise_label']}')),
   body:ListView(padding:const EdgeInsets.all(18),children:[
    Text('${b['lesson_title_as_extracted']??'Activity Book'}',style:const TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy)),
    const SizedBox(height:6),
    Wrap(spacing:8,runSpacing:8,children:[
     Chip(label:Text('Unit ${b['unit']}')),
     Chip(label:Text('Printed page ${b['printed_page']}')),
     Chip(label:Text('Exercise ${b['exercise_label']}')),
    ]),
    const SizedBox(height:12),
    Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
     const Text('Original Activity Book text',style:TextStyle(fontWeight:FontWeight.bold,color:blue)),
     const SizedBox(height:12),
     if(looksLikeSetWords) _buildSetWordsTable() else SelectableText('${b['source_text_block']??b['heading_as_extracted']??''}',textDirection:TextDirection.ltr,style:const TextStyle(fontSize:18,height:1.7)),
    ]))),
    const SizedBox(height:12),
    const Text('إجابتك / Your answer',style:TextStyle(fontWeight:FontWeight.bold,color:navy)),
    const SizedBox(height:6),
    TextField(controller:answerController,minLines:2,maxLines:5,textDirection:TextDirection.ltr,decoration:const InputDecoration(hintText:'اكتب إجابتك هنا — Write your answer here',border:OutlineInputBorder(),alignLabelWithHint:true)),
    const SizedBox(height:8),
    const Card(color:Color(0xFFFFF4D6),child:Padding(padding:EdgeInsets.all(12),child:Text('اكتب إجابتك في المساحة أعلاه. لا يُضاف تصحيح آلي أو مفتاح إجابة إلا إذا كان موثقاً في صفحة المصدر.',style:TextStyle(color:Color(0xFF6B4E16))))),
    FilledButton.icon(onPressed:()=>showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('تم إنهاء المحاولة'),content:const Text('تم تسجيل انتهاء المحاولة في هذه الشاشة. استخدم ملف الملزمة للمراجعة عند الحاجة.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('حسناً'))])),icon:const Icon(Icons.save_outlined),label:const Text('إنهاء المحاولة')),
   ]));
 }
 Widget _buildSetWordsTable(){
  final rows=<List<String>>[];
  for(final line in lines){
   final parts=line.split(RegExp(r'\s{2,}')).map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList();
   if(parts.length>=2) rows.add(parts.take(2).toList());
  }
  if(rows.length<2) return SelectableText(lines.join('\n'),textDirection:TextDirection.ltr,style:const TextStyle(fontSize:18,height:1.7));
  return SingleChildScrollView(scrollDirection:Axis.horizontal,child:DataTable(
   headingRowColor:WidgetStateProperty.all(const Color(0xFFE7F0F8)),
   columns:[const DataColumn(label:Text('Set',style:TextStyle(fontWeight:FontWeight.bold))),const DataColumn(label:Text('Words',style:TextStyle(fontWeight:FontWeight.bold)))],
   rows:rows.map((r)=>DataRow(cells:[DataCell(Text(r[0],style:const TextStyle(fontSize:15))),DataCell(Text(r[1],style:const TextStyle(fontSize:15)))] )).toList(),
  ));
 }
}

