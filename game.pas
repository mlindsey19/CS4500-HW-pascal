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

	thisCircleVisited, N, k, i, nextCircle :integer;
	arrayOfArrows : array of arrow;
	currentCircle : integer;
	arrayOfCircleVisited : array of integer;
	numCirclesVisited : integer;

procedure assignArrow(var s : string);
	begin
		val(	s[1], arrayOfArrows[i].source);
		val(	 s[3], arrayOfArrows[i].destination);
		dec(arrayOfArrows[i].source);
		dec(arrayOfArrows[i].destination);
	end;
procedure readFile();

	var
		s : string;

	begin
	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);
	
	setLength(arrayOfCircleVisited, N );
	setLength(arrayOfArrows, k );
	for i:= 0 to (k - 1)  do
		begin
			readln(arrowFile, s);
			assignArrow(s);
		end;
	close(arrowFile);
	end;


procedure goToNextCircle();
var
	r : integer;

	begin

	randomize;
	repeat
			if (arrayOfCircleVisited[currentCircle] = 0) then	
				inc(numCirclesVisited); 

		inc(arrayOfCircleVisited[currentCircle]);

		repeat
			r := random(k); {seems argument is exclusive so -1 is not needed}
		until arrayOfArrows[r].source = currentCircle;


		nextCircle := arrayOfArrows[r].destination;
		currentCircle := nextCircle;

	until numCirclesVisited = N;
	end;

begin   {main}

	readFile();
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
end.
