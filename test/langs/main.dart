import 'package:antlr4/antlr4.dart';
import 'ArrayInitParser.dart';
import 'ArrayInitLexer.dart';
import 'dart:io';
import 'dart:convert';

class TreeShapeListener implements ParseTreeListener {
  @override
  void enterEveryRule(ParserRuleContext ctx) {
    RuleContext? currParent = ctx.parent;
    while (currParent != null) {
      stdout.write("  ");
      currParent = currParent.parent;
    }

    print(ctx.text);
  }

  @override
  void exitEveryRule(ParserRuleContext node) {
  }

  @override
  void visitErrorNode(ErrorNode node) {
  }

  @override
  void visitTerminal(TerminalNode node) {
  }
}

void traverse(List<String> ruleNames, Vocabulary vocab, ParseTree tree, Map map) {
  Token? token;
  if (tree is TerminalNode) {
    token = (tree as TerminalNode).symbol;
  } else if (tree is ErrorNode) {
    token = (tree as ErrorNode).symbol;
  } else if (tree is RuleContext) {
    map["rule"] = ruleNames[(tree as RuleContext).ruleIndex];
  }

  if (token != null) {
    var symbolicName = vocab.getSymbolicName(token.type);
    if (symbolicName != null) map["vocab_symbol"] = symbolicName;
    map["type"] = token.type;
    map["text"] = token.text;
  }

  if (tree.childCount > 0) {
    map["children"] = [];

    for (var i = 0; i < tree.childCount; i++) {
      var currChild = tree.getChild(i);
      if (currChild == null) break;
      var childData = {};
      traverse(ruleNames, vocab, currChild, childData);
      map["children"].add(childData);
    }
  }
}

void main(List<String> args) async {
  ArrayInitLexer.checkVersion();
  ArrayInitParser.checkVersion();
  final input = await InputStream.fromStream(stdin);
  final lexer = ArrayInitLexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = ArrayInitParser(tokens);
  parser.addErrorListener(DiagnosticErrorListener());
  parser.buildParseTree = true;
  final tree = parser.top_level();

  Map treeData = {};
  traverse(parser.ruleNames, parser.vocabulary, tree, treeData);
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  print(encoder.convert(treeData));
}
