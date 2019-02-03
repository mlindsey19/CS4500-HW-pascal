program circleGame;

const
	FILENAME = 'arrowFile.txt';
Type
	arrow = Record
		source	    : integer;
		destination : integer;
	End;
var
	arrowFile : Text;
	N : integer; {number of circles}
	k : integer; {number of arrows}
	i : integer; {iterator}
	s : string; {buffer for arrow directions}
	nextCircle : integer; {value of next circle}
	arrayOfArrows : array of arrow;
	arrayofStrings : string;	
	currentCircle : integer;
	arrayOfCircleVisited : array of integer;
	numCirclesVisited : integer;

	{*
	this will create the array of arrow struct
	place this int the loop reading the file
	sets the source and destination int. used the destination in to set the pointer.
	*}
procedure assignArrow();
	begin
		for i:= 0 to (k - 1) do 
			begin
				val(	s[1], arrayOfArrows[i].source);
				val(	 s[3], arrayOfArrows[i].destination);

			end;
	end;
{*
	read file opens file, reads first two lines, then assigns N, k values
	then sets length for arrays and reads the rest of the file to the arrayofStrings 
*}
procedure readFile();
	begin
	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);
	
		{use N and k to set lenth of arrays, then read the rest of the file}
	setLength(arrayOfCircleVisited, N);
	setLength(arrayOfArrows, k );
	setLength(arrayOfStrings, k);
	for i:= 0 to (k - 1) do
		begin
			readln(arrowFile, s);
			assignArrow();
		end;
	close(arrowFile);
	end;
	{*
	check if currnt circle has been visited
	if not add to total visisted and check if all have been visited
	else increment circled visited array and change current circle
	*}


	{*
	get random number
	mod number to k
	check if souce of arrow is current else try again
	*}
procedure getNextCircle();
var
	r, thisCircleVisited: integer;

	begin
		r := random(k);
		thisCircleVisited := arrayOfCircleVisited[currentCircle];
		if (r = thisCircleVisited ) then
			nextCircle := r
		else
			getNextCircle;
	end;


procedure goToNextCircle();
var
	thisCircleVisited : integer;

	begin

		thisCircleVisited := arrayOfCircleVisited[currentCircle];
		if (thisCircleVisited = 0) then	
			inc(numCirclesVisited);
		inc(arrayOfCircleVisited[currentCircle]);
		if ( numCirclesVisited = N ) then
			exit;
	getNextCircle();
	currentCircle := nextCircle;
	goToNextCircle;
	end;

begin   {main}

	randomize;

	readFile();
	assignArrow();
	currentCircle := 0;
	numCirclesVisited := 0;
	for i := 0 to (N -1) do
		begin
		arrayOfCircleVisited[i] := 0;
		end;
	goToNextCircle();
	for i:=0 to (N-1) do 
	begin 
		writeln(arrayOfCircleVisited[i]);
	end;
writeln('pressenter to exit');
readln;
end.
