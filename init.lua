-- setting up local variables 
local screen = platform.window;
local h = screen:height();
local w = screen:width();

-- Setting up variables needed for calculations
var.store("test",1);
var.store("UnitMatrix", {{1,0,0},{0,1,0},{0,0,1}});
var.store("SystemMatrix", {{1,0,0},{0,1,0},{0,0,1}});
var.store("ZeroMatrix",{{0}, {0} ,{0}});

-- This is the entry of our program. This executes when the document gets loaded in the calculator 
function on.paint(gc)
	-- We print a counter in the top left corner to see if the program is still responsive
	counter = var.recall("test");
	gc:drawString(tostring(counter),0,20);
	var.store("test", counter+1);

	-- Now we print the eigenvalues of the SystemMatrix
	gc:drawString("The eigenvalues are:", 0, 40);
	local result = calculateEigenValues("SystemMatrix");
	gc:drawString(tostring(var.recallAt("SystemMatrix",1,1)),40,20);
	local loopcount = 0;
	for index, value in pairs(result) do
		gc:drawString("Eigenvalue "..tostring(index).." is "..tostring(value), 10, 60 +20*loopcount);
		loopcount = loopcount +1;
	end

	-- Make a list with unique eigenvalues
	local unique = {};
	local found = false;
	for _, v in pairs(result) do
		for index, value in pairs(unique) do
			if value == v then
				found = true;
			end
		end
		if found == false then
			unique[#unique+1] = v;
		end
		found = false;
	end

	-- Now we print the eigenvector of the SystemMatrix
	gc:drawString(tostring(#unique), 60,20);
	loopcount = 0;
	gc:drawString("The eigenvectors are:", 0, 120);
	for index, eigenvalue in pairs(unique) do
		gc:drawString(tostring(eigenvalue)..":",10, 140+20*loopcount);
		local vector, error = calculateEigenVector("SystemMatrix", eigenvalue, "UnitMatrix", "ZeroMatrix");
		gc:drawString(tostring(vector), 40, 140+20*loopcount);
		loopcount = loopcount + 1
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

-- This function calculates the eigenvector of a given matrix for a given eigenvalue
function calculateEigenVector(matrix, eigenvalue, unitmatrix, zerovector)
	return math.evalStr("solve(("..matrix.."-"..tostring(eigenvalue)..unitmatrix..")[[x][y][z]]="..zerovector..",x,y,z)");
end
