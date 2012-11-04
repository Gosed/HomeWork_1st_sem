uses usstr_kv,UStackQueue,sysutils;

var
  outst: string;
  st: CChStack;
  sti: CIStack;
  val: array[0..255] of longint;

function priority(ch: char):byte;
begin
  case ch of
    '$': priority:=0;
    '(': priority:=1;
    '+','-': priority:=2;
    '*','/': priority:=3;
  end;
end;

procedure RPN(var outstr:string);
var
  c:char;

begin
  outstr:='';
  while (nxtc <> EOS) and (not wasErr) do
    case curc of
      'a'..'z' : outstr:=outstr+curc;
      '+','-','*','/' :
      begin
        while priority(st.top) >= priority(curc) do
          outstr:=outstr+st.pop;
        st.push(curc);
      end;
      '(' : st.push(curc);
      ')' :
      begin
        c:=st.pop;
        while c<>'(' do begin
          outstr:=outstr+c;
          c:=st.pop;
        end;
      end
      else
        writeln('Недопустимый оператор');
    end;
  c:=st.pop;
  while c<>'$' do begin
    outstr:=outstr+c;
    c:=st.pop;
  end;
end;

procedure valueDef;
var s:string;
  ch:char;
begin
  while nxtc <> EOS do
    case curc of
      'a'..'z':
      begin
        ch:=curc; nxtc; s:='';
        while nxtc <> ';' do
          s:=s+curc;
        val[ord(ch)]:=StrToInt(s);
      end;
    end;
end;

function valueRPN(pol_str:string):integer;
var
  curc:char;
  iss,ls:byte;
  var1,var2:integer;
begin
  iss:=1;
  ls:=length(pol_str);
  while iss <= ls do begin
    curc:=pol_str[iss];
    case curc of
      'a'..'z': sti.push(val[ord(curc)]);
      '+':
      begin
        var1:=sti.pop;
        var2:=sti.pop;
        sti.push(var1 + var2);
      end;
      '*':
      begin
        var1:=sti.pop;
        var2:=sti.pop;
        sti.push(var1 * var2);
      end;
      '/':
      begin
        var1:=sti.pop;
        var2:=sti.pop;
        sti.push(var2 div var1);
      end;
      '-':
      begin
        var1:=sti.pop;
        var2:=sti.pop;
        sti.push(var2 - var1);
      end;
    end;
    inc(iss);
  end;
  valueRPN:=sti.pop;
end;


begin
  st.Build;
  sti.Build;
  writeln('Введите арифметическое выражение( пустая строка - выход): ');
  readln(in_str);
  while (in_str <>'') do begin
    initScanStr;
    RPN(outst);
    writeln;
    writeln('Введите соотв. значения переменных: '); readln(in_str);
    writeln;
    initScanStr;
    ValueDef;
    writeln('Значение выражения = ',valueRPN(outst));
    writeln;
    write('Введите арифметическое выражение: '); readln(in_str);
  end;
  writeln('Нажмите Enter!');
  readln;
end.
