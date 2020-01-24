#
# This example shows how to write a basic JSON parser
#
# The code is short and clear, and outperforms every other parser (that's written in Python).
# For an explanation, check out the JSON parser tutorial at /docs/json_tutorial.md
#

import glob
import sys
import pprint

from lark import Lark, Transformer, Visitor, v_args


class Function:
    def __init__(self, name: str, arguments, returntype: str):
        self.name = name
        self.arguments = arguments
        self.returntype = returntype

    def __str__(self):
        if self.name.startswith('__'):
            return None
        if self.arguments is None:
            self.arguments = []
        return "### {}({}): `{}`".format(self.name, ", ".join(self.arguments), self.returntype)



class SQLTransformer(Transformer):
    def __init__(self, **kwargs):
        self.functions = dict()

    @v_args(inline=True)
    def string(self, s):
        return s[1:-1].replace('\\"', '"')

    def fun_name(self, children):
        return children[1]

    def statements(self, statements):
        functions = []
        for statement in statements:
            if isinstance(statement, Function):
                functions.append(statement)
        return statements, functions

    def create_type_stmt(self, children):
        return ""
    def create_cast_stmt(self, children):
        return ""
    def create_oper_stmt(self, children):
        return ""

    # create function
    @v_args(inline=True)
    def create_func_stmt(self, name: str, arguments, returntype, *opts):
        if name.startswith('__'):
            return None

        return Function(name, arguments, returntype)

    @v_args(inline=True)
    def comment_on_stmt(self, type, text):
        return text

    # comment on function
    @v_args(inline=True)
    def comment_on_function(self, name, arguments):
        return {
            "on": "function",
            "name": name,
            "arguments": arguments
        }

    def argument_list(self, children):
        return children

    @v_args(inline=True)
    def argument(self, name, argtype, default=None):
        out = ""
        if name:
            out += name + " "
        out += "`{}`".format(argtype)
        if default:
            out = "[{} = {}]".format(out,default)
        return out

    def SIGNED_NUMBER(self, children):
        return int(children)

    def CNAME(self, cname):
        return str(cname)

    true = lambda self, _: "`true`"
    false = lambda self, _: "`false`"
    number = v_args(inline=True)(int)


heading = None
def comment(x):
    global heading
    if (heading is None and not x.startswith('-- -') and not x.startswith('-- complain')):
        heading = x[3:]

parser = Lark.open('sql.lark', parser='lalr', maybe_placeholders=True, lexer_callbacks={'SINGLE_COMMENT': comment})

def sql2md(file):
    with open(file) as f:
        sql = f.read()
        parse_tree = parser.parse(sql)
        return SQLTransformer(visit_tokens=True).transform(parse_tree)

"""
The concept:

We don't want to manually keep API docs in sync with SQL files.

So instead we should generate the docs from the sql/install/*.sql files.

We have the following things to document:
    * Type
    * Cast (put in same section as the type)
    * Operator
    * Function

Some functions do not need docs, we can signal this by not applying a comment.
This is internal operator functions for example.

We should parse the sql files, extract the above, and then document all things that
have comments applied.

We should probably hardcode a list of things that should not be documented, so we can
fail if new function are undocumented.

"""

if __name__ == '__main__':
    files = glob.glob(sys.argv[1])
    for file in files:
        statements, functions = sql2md(file)
        docs = "\n\n".join([str(stmt) for stmt in statements if stmt])
        print("\n## {}\n".format(heading))
        print(docs)
        heading = None
