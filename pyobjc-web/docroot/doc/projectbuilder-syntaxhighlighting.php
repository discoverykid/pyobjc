<?
    $title = "Project Builder Python Support";
    $cvs_author = '$Author: ronaldoussoren $';
    $cvs_date = '$Date: 2004/05/30 18:56:39 $';

    include "header.inc";
?>
<table class="docinfo" frame="void" rules="none">
<col class="docinfo-name" />
<col class="docinfo-content" />
<tbody valign="top">
<tr><th class="docinfo-name">Author:</th>
<td>Bill Bumgarner</td></tr>
<tr><th class="docinfo-name">Contact:</th>
<td>&lt;<a class="reference" href="mailto:bbum&#64;codefab.com">bbum&#64;codefab.com</a>&gt;</td></tr>
<tr><th class="docinfo-name">Version:</th>
<td>0.1 (unsupported)</td></tr>
<tr><th class="docinfo-name">Date:</th>
<td>12/16/2002</td></tr>
</tbody>
</table>
<div class="warning">
<p class="admonition-title">Warning</p>
None of this is documented or supported by <strong>Apple</strong>.  Don't ask <strong>Apple</strong> for
support and don't blame me if something breaks.  A lot could break as
<strong>Project Builder</strong> stores a tremendous amount of highly dynamic information in
both the user defaults and within project files.</div>
<div class="contents topic" id="contents">
<p class="topic-title"><a name="contents">Contents</a></p>
<ul class="simple">
<li><a class="reference" href="#installation" id="id2" name="id2">Installation</a></li>
<li><a class="reference" href="#documentation" id="id3" name="id3">Documentation</a></li>
<li><a class="reference" href="#to-do" id="id4" name="id4">To Do</a></li>
<li><a class="reference" href="#misc" id="id5" name="id5">Misc.</a></li>
</ul>
</div>
<p>Triple-quoted strings are not always treated correctly by Project Builder. This
seems to be a Project Builder bug.</p>
<div class="section" id="installation">
<h1><a class="toc-backref" href="#id2" name="installation">Installation</a></h1>
<p>Create the directory 'Specifications' within
<em>~/Developer/ProjectBuilder Extras/</em> or <em>/Developer/ProjectBuilder
Extras/</em>:</p>
<pre class="literal-block">
mkdir -p ~/Developer/ProjectBuilder\ Extras/Specifications/
</pre>
<p>Copy the specification files into that directory:</p>
<pre class="literal-block">
cp Python.pb*spec ~/Developer/ProjectBuilder\ Extras/Specifications/
</pre>
<p>The binary installer will install the specifications for you.</p>
</div>
<div class="section" id="documentation">
<h1><a class="toc-backref" href="#id3" name="documentation">Documentation</a></h1>
<p>The version of Project Builder that ships with the December Developer Tools
modularizes the support for file types and syntax based colorizing of
source files.  The base mechanisms and definitions are found in:</p>
<p><a class="reference" href="file:///System/Library/PrivateFrameworks/PBXCore.framework/Resources/">file:///System/Library/PrivateFrameworks/PBXCore.framework/Resources/</a></p>
<p>Not surprisingly, Apple has provided a mechanism for augmenting and
overriding the configuration information found within the PBXCore
framework.  By creating a 'Specifications' directory within any of the
<em>ProjectBuilder Extras</em> directories (<em>/Developer/ProjectBuilder Extras</em>
and <em>~/Developer/ProjectBuilder Extras</em> being the two most common).</p>
<p>All of the various specification files are simply property lists.  The file
names do not appear to be significant beyond the extension.  That is,
<em>Python.pblangspec</em> could have been called <em>Foo.pblangspec</em> and it would still
work as expected.</p>
<p>The contents of the two files were determined largely by looking through the
files found in the PBXCore framework.  The list of keywords for python was
generated by python itself:</p>
<pre class="literal-block">
In [1]: import keyword            
In [2]: keyword.kwlist
Out[2]: 
['and',
 'assert',
 'break',
 'class',
 'continue',
 'def',
 'del',
 'elif',
 'else',
 'except',
 'exec',
 'finally',
 'for',
 'from',
 'global',
 'if',
 'import',
 'in',
 'is',
 'lambda',
 'not',
 'or',
 'pass',
 'print',
 'raise',
 'return',
 'try',
 'while',
 'yield']
</pre>
</div>
<div class="section" id="to-do">
<h1><a class="toc-backref" href="#id4" name="to-do">To Do</a></h1>
<ul class="simple">
<li>There are a number of other specification files found within the PBXCore.  Of
particular relevance to Python would be the Compiler Specifications.  It
would be extremely handy to be able to check syntax and compile Python code
from within PBX directly.   This appears to be a matter of both specifying
how the compiler should be invoked and providing a set of regular
expressions for parsing the output.</li>
<li>Instead of invoking Python directly, a compiler specification that used
<a class="reference" href="http://pychecker.sourceforge.net/">PyChecker</a> would provide both syntactical checker and higher level script
integrity tests.</li>
<li>Expanding the language definition to include a list of alternative keywords
would provide for highlighting many common Python constructs and modules, as
well.</li>
<li>Looking at the internals to PBXCore, support for context-clicking (i.e. cmd-
and opt- double-clicking on keywords found in Python source) could be
supported if one were to build a custom Python Parser/Lexer as a PBX
plugin.</li>
<li>Support for Jython.  On the syntax front, this would be a matter of
duplicating a number of the keyword bits from the Java configuration.  On
the compiler front, support would focus on feeding through to the mechanism
that turns Python source into .class files.   All of this assumes that
Python and Jython source can (and should?) be differentiated.</li>
</ul>
</div>
<div class="section" id="misc">
<h1><a class="toc-backref" href="#id5" name="misc">Misc.</a></h1>
<p>This README is formatted as <a class="reference" href="http://docutils.sourceforge.net/docs/rst/quickstart.html">reStructuredText</a> input.  From it, the HTML and other
formats can be automatically generated with the <a class="reference" href="http://docutils.sourceforge.net/">docutils tools</a>.</p>
</div>
</div>
<?
    include "footer.inc";
?>