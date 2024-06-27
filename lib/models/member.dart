class member{
  final int m_id;
  final String m_name;
  final String m_batch;


  member({required this.m_id, required this.m_name, required this.m_batch});

  factory member.fromJson (Map<String,dynamic> json){
    return member(
      m_id: json['m_id'],
      m_name: json['m_name'],
      m_batch: json['m_batch'],
    );
  }

  int getID(){
    return m_id;
  }

  @override
  String toString(){
    return 'member{m_id: $m_id, m_name: $m_name, m_batch: $m_batch}';
  }

}