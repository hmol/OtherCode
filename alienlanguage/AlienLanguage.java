package alienlanguage;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

public class AlienLanguage {

	static int lettersCount, wordsCount, testCasesCount;
	static String[] wordsArray, testCasesArray;
	
	final static String INPUT_PATH = "C:\\codejam\\A-large-practice.in";
	final static String OUTPUT_PATH = "C:\\codejam\\large.out";
	final static String OUTPUT_STRING = "Case #%s: %s\n";
	
	public static void main(String[] args) throws IOException {
			readAlienFile();
			writeOutputFile();
	}

	//Reads the Alien file, puts words and testcases into arrays
	private static void readAlienFile() throws IOException {
		BufferedReader in = new BufferedReader(new FileReader(INPUT_PATH));
		String line;

		findValuesFirstLine(in.readLine());
		
		wordsArray = new String[wordsCount];
		testCasesArray = new String[testCasesCount];
		
		//Read all words into array
		for(int i = 0; i < wordsCount && (line = in.readLine()) != null; i++)
			wordsArray[i] = line;
		
		//Read all testcases into array
		for(int i = 0; i <= testCasesCount && (line = in.readLine()) != null; i++)
			testCasesArray[i] = ConvertToRegEx(line);

		in.close();
	}

	//Writes the correct output based on the words and testcases (converted to regex)
	private static void writeOutputFile() throws FileNotFoundException {
		PrintWriter out = new PrintWriter(OUTPUT_PATH);
		
		for(int i = 0; i < testCasesCount; i++)
		{
			int matches = 0;
			
			for(String s : wordsArray)
				if(s.matches(testCasesArray[i]))
					matches++;
			
			out.write(String.format(OUTPUT_STRING, (i+1), matches));		
		}	

		out.close();
	}
	
	//Parses the values of the first line, and declares the variables correct	
	private static void findValuesFirstLine(String line) {
		
		String[] firstLine = line.split(" ");
		
		//Find the neccecary values to start with
		lettersCount = Integer.parseInt(firstLine[0]);
		wordsCount = Integer.parseInt(firstLine[1]);
		testCasesCount = Integer.parseInt(firstLine[2]);
	}
	
	public static String ConvertToRegEx(String testCase)
	{
		testCase = testCase.replace('(', '[');
		testCase = testCase.replace(')', ']');
		return testCase;
	}
}