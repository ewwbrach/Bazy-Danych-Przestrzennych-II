#changelog
#Data utworzenia: 27.12.2023
#automatyzacja przetwarzania 


#---------------------------------------------------------------------------------------
try{

$TIMESTAMP = Get-Date -Format MMddyyyy
$INDEXNUMBER = 400444
# New-Item -Path 'C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED' -ItemType Directory

# Specify the path to the directory
$directoryPath = 'C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED'

# Check if the directory already exists
if (Test-Path -Path $directoryPath -PathType Container) {
    # If it exists, remove the existing directory
    Remove-Item -Path $directoryPath -Recurse -Force
    Write-Host "Existing directory removed."
}

# Create the new directory
New-Item -Path $directoryPath -ItemType Directory
Write-Output("$TIMESTAMP - stworzenie folderu -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - stworzenie folderu -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}




#---------------------------------------------------------------------------------------
#popbranie plików

try{


$adres1 = "http://home.agh.edu.pl/~wsarlej/dyd/bdp2/materialy/cw10/InternetSales_new.zip"
$zapisz_jako1 = "C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\InternetSales_new.zip"


$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($adres1,$zapisz_jako1)

 
    Write-Output("$TIMESTAMP - pobranie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - pobranie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}


try{

$7ZipPath = "C:\Program Files\7-Zip\7z.exe"
$zipFile = '"C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\InternetSales_new.zip"'
$zipFilePassword = "bdp2agh"
$extraxtPath = 'C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10'
$command = "& '$7ZipPath' e -o'$extraxtPath' -tzip -p$zipFilePassword $zipFile"

iex $command

Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}



$badFilePath = "C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\InternetSales_new.bad_$timestamp.txt"
# Read the contents of the extracted file
$output = $extraxtPath + "\InternetSales_new.txt"

$sourceFilePath = $extraxtPath + "\InternetSales_new.txt"
$content = Get-Content -Path $sourceFilePath


# ------------------------- odrzuć puste linie -----------------------
try{

if ($content -contains '')  {
    Write-Output Get-Content -Path $output | Where-Object { $_ -eq '' }   >> $badFilePath
    #Write-Output Get-Content -Path $output | Where-Object { $_ -eq '|' } >> $badFilePath

    Write-Host "Plik zawiera puste linie."
} else {
    Write-Host "Plik nie zawiera pustych linii."
}


# Ścieżka do pliku wynikowego bez pustych linii
$destinationFilePath = $badFilePath

# Wczytaj zawartość oryginalnego pliku


# Usuń puste linie
$filteredContent = $content | Where-Object { $_ -match '\S' }

$filteredContent | Out-File -FilePath $output -Force
$filteredContent.Count

Write-Output("$TIMESTAMP - puste linie -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - puste linie -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}




# ---------------------- pozostaw tylko unikalne wiersze ---------------------
try {
$tab = @()

$tab = $filteredContent | Group-Object | Where-Object { $_.Count -gt 1 } | Select -ExpandProperty Name

$tab.Count


$filteredContent = $filteredContent | select -Unique

$filteredContent.Count

$filteredContent | Out-File -FilePath $output -Force

$tab | Out-File -FilePath $badFilePath -Force
Write-Output("$TIMESTAMP - unikalne wiersze -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - unikalne wiersze -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}


# ------------- pozostaw wiersze, które mają ilość kolumn taką jak nagłówek pliku -------------------

try{

# Wiersz z nagłówkiem
$header = $content[0]

# Wiersze, które mają tę samą ilość kolumn, co nagłówek
$filteredContent = $filteredContent| Where-Object { ($_ -split '\|').Count -eq ($header -split '\|').Count }

$badContent = $filteredContent | Where-Object { ($_ -split '\|').Count -ne ($header -split '\|').Count }


$filteredContent.Count

# Zapisz wynik do tego samego pliku, nadpisując oryginalną zawartość
$filteredContent | Out-File -FilePath $output -Force

$badContent | Out-File -FilePath $badFilePath -Force

Write-Output("$TIMESTAMP - kolumny i naglowek -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}
catch
{
    Write-Output("$TIMESTAMP - kolumny i naglowek -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}



# --------------------- kolumna OrderQuantity może przyjmować maksymalną wartość 100 --------------------------------

try{


$filteredContent = $filteredContent| ConvertFrom-Csv -Delimiter "|"

$badContent = $filteredContent | Where-Object { $_.OrderQuantity -ge 100 }

$validContent = $filteredContent | Where-Object { $_.OrderQuantity -lt 100 }

$filteredContent.Count
$filteredContent | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $output -Encoding UTF8
$badContent | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $badFilePath -Encoding UTF8
Write-Output("$TIMESTAMP - kolumna OrderQuantity -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - kolumna OrderQuantity -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}


# -------- brak wartości w SecretCode (usuń wszelkie wartości SecretCode przed przeslaniem do pliku .bad) -------------

try{

$filteredContent = $filteredContent | ForEach-Object { $_.PSObject.Properties['SecretCode'].Value = "lalalal"; $_ }


$filteredContent | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $output -Encoding UTF8

Write-Output("$TIMESTAMP - usuwanie wartosci -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - usuwanie wartosci -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}


# --------- Customer_Name powinno być zapisane w formacie "nazwisko,imie" ------------------------

try{

$filteredContent = $content| ConvertFrom-Csv -Delimiter "|"


# Array to store objects with invalid format
$invalidObjects = @()
$valid = @()

$filteredContent | ForEach-Object {
    $nameParts = $_.Customer_Name -split ','  # Split the Customer_Name
    if ($nameParts.Count -eq 2) {
        $valid += $_
        # Valid format
        # You can perform further actions if needed with the valid data
    } else {
        # Invalid format
        Write-Host "Invalid format for: $($_.Customer_Name)"
        $invalidObjects += $_
    }
}






$valid | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $output -Encoding UTF8
$invalidObjects | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $badFilePath -Encoding UTF8
Write-Output("$TIMESTAMP - spraawdzanie formatu kolumny -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}
catch{
Write-Output("$TIMESTAMP - spraawdzanie formatu kolumny -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}

# -------- podziel Customer_Name na dwie osobne kolumny (z odpowiednim separatorem i bez ""): FIRST_NAME, LAST_NAME -----------

try{



$filteredContent = $valid | ForEach-Object {
    $nameParts = $_.Customer_Name -split ','  # Split last name and first name

    
    $_ | Add-Member -MemberType NoteProperty -Name FIRST_NAME -Value $nameParts[1]
    $_ | Add-Member -MemberType NoteProperty -Name LAST_NAME -Value $nameParts[0]

    
    $_
}


$filteredContent = $filteredContent | ForEach-Object {
    $_.PSObject.Properties.Remove('Customer_Name')
    $_
}

$filteredContent | ConvertTo-Csv -Delimiter '|' -NoTypeInformation | Out-File -FilePath $output -Encoding UTF8
$filteredContent.Count

(Get-Content $output) -replace '"', '' | Set-Content $output

Write-Output("$TIMESTAMP - podzial na kolumny First name i last name -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}
catch
{
    Write-Output("$TIMESTAMP - podzial na kolumny First name i last name -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}



# ----------------------- w bazie MySQL (lub innej) utworzy tabelę CUSTOMERS_${NUMERINDEKSU} -------------------------------------------

try{

 Set-Location 'C:\Program Files\PostgreSQL\13\bin\'

    $User = "postgres"
    $Password = "ew123"
    $env:PGPASSWORD = $Password
    $Database = "postgres"
    $NewDatabase = "customers"
    $newTable = "CUSTOMERS_${INDEXNUMBER}"
    $Serwer  ="PostgreSQL 13"
    $Port = "5432"

    psql -U postgres -d $NewDatabase -w -c "DROP TABLE IF EXISTS $newTable"
    psql -U postgres -d $Database -w -c "DROP DATABASE IF EXISTS $NewDatabase"

    psql -U postgres -d $Database -w -c "CREATE DATABASE $NewDatabase"
 psql  -U postgres -d $NewDatabase -w -c "CREATE TABLE IF NOT EXISTS $newTable (ID INTEGER, ProductKey INTEGER, CurrencyAlternateKey VARCHAR(5), OrderDateKey VARCHAR(50), OrderQuantity INTEGER, UnitPrice float,SecretCode VARCHAR(10), FIRST_NAME VARCHAR(100), LAST_NAME VARCHAR(100) )"
 Write-Output("$TIMESTAMP - tworzenie tabeli -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
 }
 catch{
 Write-Output("$TIMESTAMP - tworzenie tabeli -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
 }

 # ----------------------------- załaduje dane ze zweryfikowanego pliku do tabeli CUSTOMERS_${NUMERINDEKSU} -------------------------

 try{
(Get-Content $output) -replace '\|\|', '|NULL|' |  Set-Content $output
(Get-Content $output) -replace ',', '.' |  Set-Content $output
$data = Get-Content -Path $output | Select-Object -Skip 1


$i = 1
# Pętla do wstawiania danych
foreach ($line in $data) {
    $values = $line -split '\|'


    # Tworzenie zapytania SQL
    psql -U postgres -d $NewDatabase -w -c "INSERT INTO $newTable (ID, ProductKey, CurrencyAlternateKey, OrderDateKey, OrderQuantity, UnitPrice, SecretCode, FIRST_NAME, LAST_NAME) VALUES ($i,$($values[0]), '$($values[1])', $($values[2]), $($values[3]), $($values[4]), $($values[5]), '$($values[6])', '$($values[7])')"
    $i = $i + 1
   
}

Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log
}

# ------------------- przeniesie przetworzony plik do podkatalogu PROCESSED dodając prefix ${TIMESTAMP}_ do nazwy pliku ----------------------------------

try{


$extraxtPath = 'C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10'
$output = $extraxtPath + "\InternetSales_new.txt"
$output2 = $extraxtPath + "\InternetSales_new2.txt"
$directoryPath = 'C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED'
$directoryPath2 = $directoryPath + "\Customers_${TIMESTAMP}_Nov2021.txt"

Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}
catch
{
Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log}


# --------------------- przeniesie przetworzony plik do podkatalogu PROCESSED dodając prefix ${TIMESTAMP}_ do nazwy pliku ----------------------------
try{

Copy-Item -Path $output -Destination $output2
Move-Item -Path $output2 -Destination $directoryPath2 -PassThru




foreach ($line in $data) {
    $values = $line -split '\|'
    $randomString = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 10 | ForEach-Object { [char]$_ })

    # Pobieranie ID (przyjmij, że jest to pierwsza kolumna w danych)
    

    # Tworzenie zapytania SQL z warunkiem WHERE
    psql -U postgres -d $NewDatabase -w -c "UPDATE $newTable SET SecretCode ='$randomString' WHERE ID = $id"
    $id = $id + 1
}
Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}
catch
{Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log}
# ----------------- uruchomi kwerendę SQL, która zaktualizuje kolumnę SecretCode w tabeli CUSTOMERS_${NUMERINDEKSU} losowym stringiem o długości 10 ------------------------

try{

 $id = 1
foreach ($line in $data) {
    $values = $line -split '\|'
    $randomString = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 10 | ForEach-Object { [char]$_ })

    # Pobieranie ID (przyjmij, że jest to pierwsza kolumna w danych)
    

    # Tworzenie zapytania SQL z warunkiem WHERE
    psql -U postgres -d $NewDatabase -w -c "UPDATE $newTable SET SecretCode ='$randomString' WHERE ID = $id"
    $id = $id + 1
}
Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log}

# -------------------- wyeksportuje zawartość tabeli CUSTOMERS_${NUMERINDEKSU} do pliku csv -----------------------

try{

Set-Location 'C:\Program Files\PostgreSQL\13\bin\'

    $User = "postgres"
    $Password = "ew123"
    $env:PGPASSWORD = $Password
    $Database = "postgres"
    $NewDatabase = "customers"
    $newTable = "CUSTOMERS_400444"
    $Serwer  ="PostgreSQL 13"
    $Port = "5432"

    # Pobierz wyniki zapytania do pliku CSV
psql -U postgres -d $NewDatabase -w -c "COPY (SELECT * FROM $newTable) TO STDOUT WITH CSV HEADER" > "C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED\${newTable}.csv"
Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log

}

catch
{Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log}

# ------------------------------------------------ skompresuje plik csv -----------------------------------------------------------

try{

Compress-Archive "C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED\${newTable}.csv" -DestinationPath "C:\Users\acer\Desktop\Geoinformatyka\Bazy danych przestrzennych II\lab10\PROCESSED\${newTable}.zip"
Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> $directoryPath\cw10_${TIMESTAMP}.log
}
catch
{Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> $directoryPath\cw10_${TIMESTAMP}.log}