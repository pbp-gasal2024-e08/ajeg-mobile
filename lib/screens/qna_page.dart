import 'package:flutter/material.dart';

class QnAPage extends StatefulWidget {
  const QnAPage({super.key});

  @override
  State<QnAPage> createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  // List of questions and answers stored persistently
  static final List<Map<String, String?>> _qnaList = [];

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  // Add a new question
  void _addQuestion(String question) {
    setState(() {
      _qnaList.add({
        'question': question,
        'answer': null,
      });
    });
    _questionController.clear();
  }

  // Add an answer to a specific question
  void _addAnswer(int index, String answer) {
    setState(() {
      _qnaList[index]['answer'] = answer;
    });
    _answerController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA'),
      ),
      body: Column(
        children: [
          // Input field to add a question
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: 'Ask a question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      _addQuestion(_questionController.text);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),

          // Display list of QnA
          Expanded(
            child: ListView.builder(
              itemCount: _qnaList.length,
              itemBuilder: (context, index) {
                final question = _qnaList[index]['question'];
                final answer = _qnaList[index]['answer'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(question ?? ''),
                    subtitle: answer != null
                        ? Text('Answer: $answer')
                        : const Text('No answer yet'),
                    trailing: answer == null
                        ? IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Answer the question'),
                                    content: TextField(
                                      controller: _answerController,
                                      decoration: const InputDecoration(
                                        labelText: 'Your answer',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_answerController.text.isNotEmpty) {
                                            _addAnswer(index, _answerController.text);
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 
