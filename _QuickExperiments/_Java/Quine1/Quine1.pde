char q = 34, c = 44, n = 10;
String[] a =
{
"char q = 34, c = 44, n = 10;",
"String[] a =",
"{",
"",
"};",
"String B() { String s = new String(); for (int i = 0; i < a.length; i++) { s += q + a[i] + q + c + n; } return s; }",
"void D() { for (int i = 0; i < a.length; i++) println(a[i]); }",
"void setup() { a[3] = B(); D(); exit(); }",

};
String B() { String s = new String(); for (int i = 0; i < a.length; i++) { s += q + a[i] + q + c + n; } return s; }
void D() { for (int i = 0; i < a.length; i++) println(a[i]); }
void setup() { a[3] = B(); D(); exit(); }
