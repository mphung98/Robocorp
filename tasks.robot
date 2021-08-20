*** Settings ***
Documentation   Template robot main suite.
Library         RPA.Browser.Selenium
Library         RPA.HTTP
Library         RPA.Excel.Files
Library         RPA.PDF

*** Keywords ***
Open the intranet website
    Open Available Browser        https://robotsparebinindustries.com/

*** Keywords ***
Log in 
    Input Text            id:username    maria
    Input Password        id:password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form

Download the excel file
    Download    https://robotsparebinindustries.com/SalesData.xlsx     overwrite=True

Fill and submit the form for one person
    [Arguments]   ${sale_report} 
    Input Text    firstname        ${sale_report}[First Name]
    Input Text    lastname         ${sale_report}[Last Name]
    Input Text    salesresult      ${sale_report}[Sales]
    Select From List by Value      salestarget     ${sale_report}[Sales Target]   
    Click Button    Submit

Fill the form using the data from the excel file
    Open Workbook    SalesData.xlsx
    ${sales_reports}=    Read Worksheet As Table    header=True
    Close Workbook
    FOR     ${sale_report}     IN     @{sales_reports}
        Fill and submit the form for one person    ${sale_report}
    END



Collect the results
    Screenshot    xpath=//div[@class="alert alert-dark sales-summary"]        ${CURDIR}${/}output${/}sales_summary.png


Export the table as a PDF
    Wait Until Element Is Visible    xpath=//div[@id="sales-results"]        
    ${sales_results_html}=        Get Element Attribute    xpath=//div[@id="sales-results"]        outerHTML
    Html To Pdf    ${sales_results_html}     ${CURDIR}${/}output${/}sales_results.pdf

Log out and close Browser
    Click Button    Log out
    Close Browser

*** Tasks ***
Open the intranet website and login
    Open the intranet website
    Log in
    Download the excel file
    Fill the form using the data from the excel file
    Collect the results
    Export the table as a PDF
    [Teardown]     Log out and close Browser

