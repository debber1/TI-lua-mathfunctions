-- setting up local variables 
local screen = platform.window;
local h = screen:height();
local w = screen:width();

-- Setting up variables needed for calculations
var.store("test",1);
var.store("UnitMatrix", {{1,0,0},{0,1,0},{0,0,1}});
var.store("SystemMatrix", {{1,0,0},{0,1,0},{0,0,1}});

-- This is the entry of our program. This executes when the document gets loaded in the calculator 
function on.paint(gc)
	-- We print a counter in the top left corner to see if the program is still responsive
	counter = var.recall("test");
	gc:drawString(tostring(counter),0,20);
	var.store("test", counter+1);
	var.monitor("test");

	-- Now we print the eigenvalues of the SystemMatrix
	gc:drawString("The eigenvalues are:", 0, 40);
	local result = calculateEigenValues("SystemMatrix");
	gc:drawString(tostring(var.recallAt("SystemMatrix",1,1)),40,20);
	local loopcount = 0;
	for index, value in pairs(result) do
		gc:drawString("Eigenvalue "..tostring(index).." is "..tostring(value), 10, 60 +20*loopcount);
		loopcount = loopcount +1;
	end
end

-- This function calls on.paint() when pressing enter
function on.enterKey()
	screen:invalidate();
end

-- This function returns the eigenvalues of a matrix stored in calculator memory
function calculateEigenValues(matrix)
	return math.eval("eigVl("..matrix..")");
end
