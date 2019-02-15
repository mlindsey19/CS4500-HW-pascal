{*
Mitch Lindsey
2/3/19
cs4500
hw1

this program will take an file with integers arranged to repespent
circles and arrows pointing to the circls, This would create a map
and the program randomly tranverses these arrows until each one has
been seen. the program prints and creates a file with the sum of all 
visits, the avg number of visits and max visits
*}

program circleGame;
Uses math, sysutils;
const
	FILENAME = 'HW1infile.txt'; {name of input file}
Type {struct for arrow with source (current circle) and destination}
	arrow = Record
		source	    : integer; 
		destination : integer;
	End;
{******************************************************}

var
arrowFile, outfile : text; {variable to hold text files}

{*
max holds max visit any circle, numCircleVisisted counts number of disinct visits, currentCircle
repesents node being "visited", sum holds total check, N is number of circles, k is number of arrows,
i is itorator for whole program(meh its set to 0 each time) nextCircle is placeholder for next visit
*}
	max, numCirclesVisited, currentCircle, sum, N, k, i, nextCircle :integer;
	arrayOfArrows : array of arrow;
	arrayOfCircleVisited : array of longint; {holds number of times visited for each circle}
	avg : real;{avg visit per circle}

	{hw2 vars}
	setOfArrows : array of arrow;
	countArray: array[1..20] of integer;{for sorting}
	wellConnectedCircls: array[1..20] of boolean;{once full, graph is strongly connected}
	tinyArraySet : array of string; {to check arrow already exists linearly, arrow struct would need nlogn passes }
	numUnqArrow : integer;

{******************************************************}


procedure addToSet(var arrow1 : arrow );
var
	arrowStr : string;

begin
	if arrow1.source < 10 then 
		 arrowStr := '0'+ intToStr(arrow1.source)
	else 
		arrowStr := intToStr(arrow1.source);

	if arrow1.destination < 10 then 
		arrowStr := arrowStr + '0'+ intToStr(arrow1.destination)
	else 
		 arrowStr := arrowStr + intToStr(arrow1.destination);
	for i := 1 to numUnqArrow do
		if arrowStr = tinyArraySet[i] then
			exit;
	inc(numUnqArrow);
	setLength(tinyArraySet, numUnqArrow);
	tinyArraySet[numUnqArrow] := arrowStr;
end;	


{******************************************************}

	{*
	this procedure parses the test file and created the arrow array
	the dec() fuction maps the arrows in the file to match the index in circle array 0-N
	*}

{******************************************************}

procedure assignArrow(var s : string);
var
	src, dst : string;
	p  : integer;
	begin

		p := pos(' ', s);
		src := copy(s, 1, (p -1));
		delete(s, 1, p);
		p:= pos(' ', s);
		delete(s,p, p);{this extra delete is in case there is a extra space after the second value}
		dst := s;


		val(	src, arrayOfArrows[i].source);
		val(	 dst, arrayOfArrows[i].destination);

		inc(countArray[ arrayOfArrows[i].destination ]);{increments count arrat for sorting}

		addToSet(arrayOfArrows[i] );
	end;

{******************************************************}
	{*
	opens the input textfile, reads number of circle and arrows and sets the length of their
	repsctive arrays
	*}

procedure checkFile();

var
	a, b :integer; {a is used to count the lines after 'k' to verify they match}
			{b is a flag to exit if file is incorrect}

begin

	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);

	a := 0;

	while not eof(arrowFile) do
		begin
			readln(arrowFile);
			inc(a);
		end;


	assign(outfile, 'HW1lindseyOutfile.txt');
	rewrite(outfile);
	b:=0;

	if a <> k then {if a does not equal k} 
begin
	writeln('the number of arrows did not match the specifications');
	writeln(outfile, 'the number of arrows did not match the specifications');
	b:=1;
end;		

	if (N < 2) or (N > 10) then 
begin
	writeln('incorrect number of circles');
	writeln(outfile, 'incorect number of circles');
	b:=1;
end;		
	if (k > 100) or (k < N) then 
begin
	writeln('incorrect number of arrows');
	writeln(outfile, 'incorrect number of arrows');
	b:=1;
end;		

		close(outfile);
	if b = 1 then 
	halt(-1); {exits program}
end;
{******************************************************}

procedure readFile(); {this will read the file, it reassigns N, k because of the reset}
var
		s : string;
	begin
	
	checkFile();

	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);
	
	{set lenghth of arrays to values from file}
	setLength(arrayOfCircleVisited, N );
	setLength(arrayOfArrows, k );
	for i:= 0 to (k - 1)  do
		begin
			readln(arrowFile, s);
			assignArrow(s);
		end;
	close(arrowFile);
	end;
{******************************************************}

procedure goToNextCircle();
var
	r : integer;

	begin

	randomize; {creates random seed each time, can not go inside loop}
	repeat
			if (arrayOfCircleVisited[currentCircle] = 0) then	
			begin
				inc(numCirclesVisited);  {this is total distinct visits, when it reache N, all circles have been seen}
				writeln('working.. ', numCirclesVisited,'/',N); {let user know of progress}
			end;

		inc(arrayOfCircleVisited[currentCircle]); {check on indivitual circle for stats}

		{randomly chose an arrow until it has the same source number as the current cirlce}
		repeat
			r := random(k); {range 0-(k-1)}
		until arrayOfArrows[r].source = currentCircle;

		{move to next circle}
		nextCircle := arrayOfArrows[r].destination;
		currentCircle := nextCircle;

	until numCirclesVisited = N;
	end;
{******************************************************}
	{adds all the visits}
procedure sumChecks();
begin
	for i:= 0 to (N - 1) do
		begin
			sum := sum + arrayOfCircleVisited[i];
		end;
end;
{******************************************************}
{sets max visit for stats}
procedure maxChecks();
begin
	max:= arrayOfCircleVisited[0];
	for i:= 1 to (N-1) do
		begin
	if max < arrayOfCircleVisited[i] then
		max:= arrayOfCircleVisited[i];
	end;
end;
{******************************************************}

procedure isGraphStrCntd(var numArrows: integer);
var
	numberOfPath2UnqCir : integer; {when == number of Circles -> go to next}
	thisCirclePathOut: array of boolean;
	maxExits, indexOfMax, j : integer;

begin
	setLength(thisCirclePathOut, N);
	maxExits := MaxIntValue(countArray);
	for i := 1 to N do 
	begin
		thisCirclePathOut[i] := false;
{ this gets the arrow that has the arrows pointing at it        }
{ all arrows pointing at the arrow will be well connected after }
		if countArray[i] = maxExits then
		begin 
			indexOfMax := i;
			countArray[i] := 0; {on the next full pass this will not be max}
			for j := 1 to numArrows do 
			begin
				if setOfArrows[j].source = indexOfMax then 
				begin
					thisCirclePathOut[setOfArrows[j].destination] := true;	
				end;

			end;
			break;
		end;

	end;

end;

begin   {main}

	readFile();
	currentCircle := 0;
	numCirclesVisited := 0;
	numUnqArrow := 0;

	{sets all visits to 0}
	for i := 1 to N do
		begin
		arrayOfCircleVisited[i] := 0;
		countArray[i] := 0;
		wellConnectedCircls[i] := false;
	end;
		goToNextCircle();
		sumChecks();
		avg := sum / N;	
		maxChecks();
		writeln('Number of Circles: ', N);
		writeln('Number of Arrows: ', k);
		writeln('Totall Checks: ', sum);
		writeln('Averger number of checks per circle: ', avg);
		writeln('Max number of check for any circle: ', max);

		assign(outfile, 'HW1lindseyOutfile.txt');
		rewrite(outfile);
			
		writeln(outfile,'Number of Circles: ', N);
		writeln(outfile,'Number of Arrows: ', k);
		writeln(outfile, 'Totall Checks: ', sum);
		writeln(outfile, 'Averger number of checks per circle: ', avg);
		writeln(outfile, 'Max number of check for any circle: ', max);
		close(outfile);

end.
