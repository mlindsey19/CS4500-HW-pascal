program circleGame;

const
	FILENAME = 'arrowFile.txt';
Type
	arrow = Record
		source	    : integer;
		destination : integer;
	End;
var
arrowFile : text;

	N, k, i, nextCircle :integer;
	arrayOfArrows : array of arrow;
	currentCircle : integer;
	arrayOfCircleVisited : array of integer;
	numCirclesVisited : integer;
	{*
	this will create the array of arrow struct
	place this int the loop reading the file

	*}
procedure assignArrow(var s : string);
	begin
		val(	s[1], arrayOfArrows[i].source);
		val(	 s[3], arrayOfArrows[i].destination);
		dec(arrayOfArrows[i].source);
		dec(arrayOfArrows[i].destination);
	end;
{*
	read file opens file, reads first two lines, then assigns N, k values
	then sets length for arrays and reads the rest of the file to the arrayofStrings 
*}
procedure readFile();

	var
		s : string;

	begin
	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);
	
		{use N and k to set lenth of arrays, then read the rest of the file}
	setLength(arrayOfCircleVisited, (N - 1));
	setLength(arrayOfArrows, (k - 1) );
	for i:= 0 to (k - 1) do
		begin
			readln(arrowFile, s);
			assignArrow(s);
		end;
	close(arrowFile);
	end;
	{*
	check if currnt circle has been visited
	if not add to total visisted and check if all have been visited
	else increment circled visited array and change current circle
	*}


procedure goToNextCircle();
var
	r, thisCircleVisited : integer;

	begin

		thisCircleVisited := arrayOfCircleVisited[currentCircle + 1]; {number of times current circle has been visited}
		if (thisCircleVisited = 0) then	;
		begin
			inc(numCirclesVisited);  {increment counter for distinct visits}
		end;

		inc(arrayOfCircleVisited[currentCircle]);

		if ( numCirclesVisited = N ) then
		begin
			exit;
		end;
	randomize;
	repeat
		r := random(k - 1) 	
	until arrayOfArrows[r].source = currentCircle;
	nextCircle := arrayOfArrows[r].destination;
	currentCircle := nextCircle;
	goToNextCircle();
	end;

begin   {main}


	readFile();
	currentCircle := 0;
	numCirclesVisited := 0;
	for i := 0 to (N -1) do
		begin
		arrayOfCircleVisited[i] := 0;
	end;
	

		writeln(N);
		writeln(k);
for i :=0 to (k - 1) do 
begin

		writeln(arrayOfArrows[i].source);
		writeln(arrayOfArrows[i].destination);
	end;
		goToNextCircle();
	for i:=0 to (N-1) do 
	begin 

		writeln(arrayOfCircleVisited[i]);
	end;


end.
