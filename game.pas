program circleGame;

const
	FILENAME = 'HW1infile.txt';
Type
	arrow = Record
		source	    : integer;
		destination : integer;
	End;
var
arrowFile, outfile : text;


	max, numCirclesVisited, currentCircle, sum, N, k, i, nextCircle :integer;
	arrayOfArrows : array of arrow;
	arrayOfCircleVisited : array of longint;
	avg : real;

procedure assignArrow(var s : string);
var
	src, dst : string;
	p :integer;
	begin

		p := pos(' ', s);
		src := copy(s, 1, (p -1));
		delete(s, 1, p);
		p:= pos(' ', s);
		delete(s,p, p);
		dst := s;

		val(	src, arrayOfArrows[i].source);
		val(	 dst, arrayOfArrows[i].destination);
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
			begin
				inc(numCirclesVisited); 
				writeln('working.. ', numCirclesVisited,'/',N);
			end;

		inc(arrayOfCircleVisited[currentCircle]);

		repeat
			r := random(k); {range 0-(k-1)}
		until arrayOfArrows[r].source = currentCircle;


		nextCircle := arrayOfArrows[r].destination;
		currentCircle := nextCircle;

	until numCirclesVisited = N;
	end;

procedure sumChecks();
begin
	for i:= 0 to (N - 1) do
		begin
			sum := sum + arrayOfCircleVisited[i];
		end;
end;
procedure maxChecks();
begin
	max:= arrayOfCircleVisited[0];
	for i:= 1 to (N-1) do
		begin
	if max < arrayOfCircleVisited[i] then
		max:= arrayOfCircleVisited[i];
	end;
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

	for i:=0 to (N-1) do 
	begin 
		writeln(arrayOfCircleVisited[i]);
	end;
end.
