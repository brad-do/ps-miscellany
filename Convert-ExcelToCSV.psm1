<#
DadOverflow.com, 2018
#>

function Convert-ExcelToCSV()
{
	Param($FileName)
	if(Test-Path $FileName -PathType Leaf)
	{
		$xlCSV = 6
		$Excel = New-Object -Com Excel.Application
		$Excel.visible = $False
		$Excel.displayalerts=$False
		$fn = (gci $FileName).FullName
		$WorkBook = $Excel.WorkBooks.Open($fn)
		foreach($worksheet in $WorkBook.Worksheets)
		{
			$csvfile = ("{0}_{1}_tab.csv" -f $fn, $worksheet.Name)
			$worksheet.SaveAs($csvfile, $xlCSV)
		}
		
		$WorkBook.Close()
		$Excel.quit()
	}
}