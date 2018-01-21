<#
DadOverflow.com

Date: 21 Jan 2018
Description: Suppose I want to calculate how old someone was at the time of a particular event, such as when that
person died?  Well, getting the years old is relatively easy; however, it takes a little bit more effort to the
remaining months and days after that.  Here's a script that does just that.  A good version two of this might be
to expose it to a module that can be loaded into a session and then called like any other cmdlet.
#>

function Get-AgePhrase($StartDate, $EndDate){
    $year_diff = [math]::floor((new-timespan -start $StartDate -end $EndDate).Days / 365.2425)
    $month_diff = 0
    $day_diff = 0
    $temp_date = $StartDate.AddYears($year_diff)

    while($temp_date -lt $EndDate){
        if($temp_date.AddMonths(1) -le $EndDate){
            $temp_date = $temp_date.AddMonths(1)
            $month_diff++
        }else{
            $temp_date = $temp_date.AddDays(1)
            $day_diff++
        }
    }
    return "{0} years, {1} months, and {2} days" -f $year_diff, $month_diff, $day_diff
}

# how old was Tom when he died?
$toms_birth_date = [datetime]"3/29/1916"
$toms_death_date = [datetime]"6/23/1984"
write-host ("Tom was {0} old when he died" -f (Get-AgePhrase -StartDate $toms_birth_date -EndDate $toms_death_date))