class RewardData {
  List<RewardListData> data = [
    RewardListData(taskname: "Daily Login", tokens: 5),
    RewardListData(taskname: "Play 5 Matchs", tokens: 8),
    RewardListData(taskname: "Win 2 Matches", tokens: 10),
  ];

  List<bool> isComplete() {
    List<bool> _list = List<bool>();

    for (int i = 0; i == 3; i++) {
      _list.add(false);
    }

    return _list;
  }
}

class RewardListData {
  final String taskname;
  final int tokens;

  RewardListData({this.taskname, this.tokens});
}
