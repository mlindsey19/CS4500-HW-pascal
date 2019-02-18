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
	max, numCirclesVisited, currentCircle, sum, N, it, k, nextCircle :integer;
	arrayOfArrows : array of arrow;
	arrayOfCircleVisited : array of longint; {holds number of times visited for each circle}
	avg : real;{avg visit per circle}

	{hw2 vars}
	setOfArrows : array of arrow;
	countArray: array of integer;{for sorting}
	wellConnectedCircles: array of boolean;{once full, graph is strongly connected}
	tinyArraySet : array of string; {to check arrow already exists linearly, arrow struct would need nlogn passes }
	numUnqArrow : integer;
	numWellconCircles: integer;{circles with path to every other circle}

{******************************************************}


procedure addToSet(var source: integer; dest : integer  );
var
	arrowStr : string;
	z : integer;
begin

	if source < 10 then 
		 arrowStr := '0'+ intToStr(source)
	else 
		arrowStr := intToStr(source);

	if dest < 10 then 
		arrowStr := arrowStr + '0'+ intToStr(dest)
	else 
		 arrowStr := arrowStr + intToStr(dest);
	for z := 1 to numUnqArrow do
		if arrowStr = tinyArraySet[z - 1] then
			exit;

	inc(numUnqArrow);
	tinyArraySet[numUnqArrow - 1] := arrowStr;
	setOfArrows[numUnqArrow - 1].source := source;
	setOfArrows[numUnqArrow - 1].destination := dest;
end;	


{******************************************************}

	{*
	this procedure parses the test file and created the arrow array
	the dec() fuction maps the arrows in the file to match the index in circle array 0-N
	*}

{******************************************************}

procedure assignArrow(var s : string; i: integer);
var
	src, dst : string;
	source, dest, p  : integer;
	
begin

	p := pos(' ', s);
	src := copy(s, 1, (p -1));
	delete(s, 1, p);
	p:= pos(' ', s);
	delete(s,p, p);{this extra delete is in case there is a extra space after the second value}
	dst := s;


	val(	src, arrayOfArrows[i].source);
	val(	 dst, arrayOfArrows[i].destination);
	{set arrow and then decrease value to equal idex of array of circles}
	dec(arrayOfArrows[i].source);
	dec(arrayOfArrows[i].destination);

	inc(countArray[ arrayOfArrows[i].destination ]);{increments count arrat for sorting}

	source := arrayOfArrows[i].source;
	dest := arrayOfArrows[i].destination;

	addToSet(source, dest);

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
	i :integer;
begin
	
	checkFile();

	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);
	
	{set lenghth of arrays to values from file}
	setLength(arrayOfCircleVisited, N );
	setLength(wellConnectedCircles, N);
	setLength(arrayOfArrows, k );
	setLength(tinyArraySet, k);
	setLength(setOfArrows, k);
	setLength(countArray, N);


	for i:= 0 to (k - 1) do
	begin
		readln(arrowFile, s);
		assignArrow(s, i);
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
			r := random(k); {range 0..k-1}
		until arrayOfArrows[r].source = currentCircle;

		{move to next circle}
		nextCircle := arrayOfArrows[r].destination;
		currentCircle := nextCircle;

	until numCirclesVisited = N;
end;
{******************************************************}
	{adds all the visits}
procedure sumChecks();
var
	i : integer;
begin
	for i:= 0 to (N - 1) do
	begin
		sum := sum + arrayOfCircleVisited[i];
	end;
end;
{******************************************************}
{sets max visit for stats}
procedure maxChecks();
var
	i : integer;
begin
	max:= arrayOfCircleVisited[1];
	for i:= 1 to (N - 1) do  
	begin
		if max < arrayOfCircleVisited[i] then
			max:= arrayOfCircleVisited[i];
	end;
end;
{******************************************************}

procedure isGraphStrCntd();
var
	numberOfPath2UnqCir : integer; {when == number of Circles -> go to next}
	thisCirclePathOut: array of boolean;
	maxExits, indexOfMax, j, i, iter, firstCircle: integer;

begin
	setLength(thisCirclePathOut, N);
	iter := 0;
	firstCircle := -1;
	for i:= 0 to (N - 1) do
		if countArray[i] = 0 then
		begin
			writeln('not connected');
			exit;
		end;

	repeat
		

		numberOfPath2UnqCir := 1; {starts with path to itself}

		maxExits := countArray[0];

		for i:= 0 to (N - 1) do
		begin
			if maxExits < countArray[i] then
				maxExits := countArray[i];
			thisCirclePathOut[i] := false;
		end;
		

		for i := 0 to (N - 1) do 
			if countArray[i] = maxExits then
			begin
				indexOfMax := i;
				countArray[i] := 0; {ddon the next full pass this will not be max}
				thisCirclePathOut[indexOfMax] := true;
				break;
			end;
		
		if iter = 0 then
			firstCircle := indexOfMax;	
		inc(iter);

	{ this gets the arrow that has the most arrows pointing at it        }
	{ all arrows pointing at the arrow will be well connected if this one is }
		if wellConnectedCircles[indexOfMax] = false then
			for i := 0 to numUnqArrow do
			begin
				for j := 0 to numUnqArrow do 
				begin {this adds unique destinations to array to verify paths from current circle} 
					if (thisCirclePathOut[setOfArrows[j].source] = true) then
					begin
						if wellConnectedCircles[setOfArrows[j].destination] = true then
						begin
							numberOfPath2UnqCir := N;
						end;
						if numberOfPath2UnqCir = N then break;
						thisCirclePathOut[setOfArrows[j].destination] := true;	
						inc(numberOfPath2UnqCir);
					end;
				end;
				if numberOfPath2UnqCir = N then
				begin
					break;
				end;
			end;


		if (numberOfPath2UnqCir <> N) then
			begin
				writeln('not connected');
				exit;
			end;

		
		if  (wellConnectedCircles[setOfArrows[indexOfMax].source] = false) then 
		begin
			wellConnectedCircles[setOfArrows[indexOfMax].source] := true; 
			for j:= 0 to numUnqArrow do
				for i:= 0 to numUnqArrow do
				begin
					{	if setOfArrows[i].destination = indexOfMax then
					begin
						if wellConnectedCircles[setOfArrows[i].source] = false then
							inc(numWellconCircles);

						wellConnectedCircles[setOfArrows[i].source] := true;
						if numWellconCircles = N then
							writeln('graph is strongly connected');
					end;}
					if wellConnectedCircles[setOfArrows[i].destination] = true then
					begin
						if wellConnectedCircles[setOfArrows[i].source] = false then
							inc(numWellconCircles);

						wellConnectedCircles[setOfArrows[i].source] := true;
						if numWellconCircles = N then
						begin
							writeln('graph is strongly connected');
							exit;
						end;
					end;
				end;
		end;
	until numWellconCircles = N;

end;



begin   {main}

	numUnqArrow := 0;
	readFile();
	currentCircle := 1;
	numCirclesVisited := 0;
	numWellconCircles := 1; {starts at one because first circle added does not increment this counter}


	isGraphStrCntd();


	{sets all visits to 0}
	for it := 0 to (N - 1) do
	begin
		arrayOfCircleVisited[it] := 0;
		countArray[it] := 0;
		wellConnectedCircles[it] := false;
	end;
	
	if numWellconCircles = N then
	begin
		goToNextCircle();
		sumChecks();
		avg :=  sum / N;	
		maxChecks();
		writeln('Number of Circles: ', N);
		writeln('Number of Arrows: ', k);
		writeln('Totall Checks: ', sum);
		writeln('Average number of checks per circle: ', formatFloat('##.#',avg));
		writeln('Max number of check for any circle: ', max);

		assign(outfile, 'HW1lindseyOutfile.txt');
		rewrite(outfile);
			
		writeln(outfile,'Number of Circles: ', N);
		writeln(outfile,'Number of Arrows: ', k);
		writeln(outfile, 'Totall Checks: ', sum);
		writeln(outfile, 'Average number of checks per circle: ', formatFloat('##.#',avg));
		writeln(outfile, 'Max number of check for any circle: ', max);
		close(outfile);
	end;
end.
