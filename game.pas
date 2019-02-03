program circleGame;

const
	FILENAME = 'arrowFile.txt';

Type
	circlePtr = ^circleNode;

	circleNode = Record
		index   : integer;
		visited : integer;
	end;
	arrow = Record
		source	    : integer;
		destination : integer;
		destPtr     : ^circleNode;
	End;
	Functor = procedure ( node : game );
var
	arrowFile : Text;
	N : integer;
	k : integer;
	a : array of integer;
	i : integer;
	s : string;
	arrayOfCircles : array of circleNode;
	arrayOfArrows : array of arrows;
	
	currentCirgle : circlePtr;

	{*
	this will create the array of arrow struct
	place this int the loop reading the file
	sets the source and destination int. used the destination in to set the pointer.
	*}
procedure assignArrow() 
	begin
		for i:= 0 to k do 
			begin
				val(	s[1], arrayOfArrows[i].source);
				val(	 s[3], arrayOfArrows[i].destination));
				arrayOfArrows[i].destPtr = arrayOfCircles[arrayOfArrows.destination]

			end;
	end;

procedure assignCircle()
	begin
		for i:= 0 to N do 
		begin
			arrayOfCircles[i].index := i;
			arrayOfCircles[i].visited := 0;
		end;
	end;

begin
	assign(arrowFile, FILENAME);
	reset(arrowFile);
	readln(arrowFile, N);
	readln(arrowFile, k);

	setLength(a, (2 * k) );
	setLength(arraystr, k );
	for i:= 0 to (k - 1) do
		begin
			readln(arrowFile, s);
		end;
	close(arrowFile);
	for i:= 0 to ((2 * k ) -1 ) do
		begin
			writeln(a[i]);
		end;
writeln('pressenter to exit');
readln;
end.
