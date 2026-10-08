namespace DynamicsNav.SaccoDatabase;

using Microsoft.Bank.BankAccount;
using System.IO;
using System.Utilities;

codeunit 90007 "Create Excel Temp. Mgt"
{
    local procedure CreateCustShareListTemplate(Rec: Record Member; var TempExcelBuffer: Record "Excel Buffer")
    var
        BankDetails: Record "Bank Account";
    begin

        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('BInSol - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(Today, 10, '<Day,2>/<Month,2>/<Year4>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(BankDetails."Bank Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Account Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Employer Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Shares Capital', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Deposits', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Iesa Savings', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Holiday Savings', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Musharaka', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('AMALGAMATION', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('BUSINESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA NORMAL DEFAULTER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Defaulter Emergency', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Defaulter IESA Normal', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('DEFAULTER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('EDUCATION', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('HOLIDAYS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA AMALGATION', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA EMERGENCY 0NE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA EMERGENCY 2', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA NORMAL', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IESA PREMIER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('MAKARIBISHO', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);

        TempExcelBuffer.AddColumn('MUSHARAKA NORMAL', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Ubora M-Loan', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('CO-OP PERSONAL', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Ubora Safaricom', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('SCHOOL FEES', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);

        TempExcelBuffer.AddColumn('COLLEGE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('EMERGENCY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('DEVELOPMENT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('COLLEGE 2', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);

    end;

    procedure GenerateCustTemplate(StartDate: Date; EndDate: Date; ProdDimension: Enum ProductDimension; ShowAll: Boolean): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "Payment Lines";
        CustMember: Record Member;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_ShareList-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        CustMember.Reset();
        if not ShowAll then begin
            CustMember.SetRange("Account Category", ProdDimension);
        end;
        if CustMember.FindSet() then begin
            CreateCustShareListTemplate(CustMember, TempExcelBuffer);
            repeat
                CreateCustDataTemplate(CustMember, TempExcelBuffer, StartDate, EndDate);
            until CustMember.Next() = 0;
        end;

        TempExcelBuffer.CreateNewBook(CustMember.TableCaption());
        TempExcelBuffer.WriteSheet(CustMember.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), 'Sharefile');
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));
    end;

    local procedure CreateCustDataTemplate(Rec: record Member; var TempExcelBuffer: Record "Excel Buffer"; StartDate: Date; EndDate: Date)
    var
        Dfilter: Text;
        LoanP: Record Loans;
    begin

        AmountPost[1] := 0;
        AmountPost[2] := 0;
        AmountPost[3] := 0;
        AmountPost[4] := 0;
        AmountPost[5] := 0;
        TotalBal[1] := 0;
        TotalBal[2] := 0;
        TotalBal[3] := 0;
        TotalBal[4] := 0;
        TotalBal[5] := 0;
        TotalBal[6] := 0;
        TotalBal[7] := 0;
        TotalBal[8] := 0;
        TotalBal[9] := 0;
        TotalBal[10] := 0;
        TotalBal[11] := 0;
        TotalBal[12] := 0;
        TotalBal[13] := 0;
        TotalBal[14] := 0;
        TotalBal[15] := 0;
        TotalBal[16] := 0;
        TotalBal[17] := 0;
        TotalBal[18] := 0;
        TotalBal[19] := 0;
        TotalBal[20] := 0;
        TotalBal[21] := 0;
        TotalBal[22] := 0;
        TotalBal[23] := 0;

        Dfilter := Format(StartDate) + '..' + Format(EndDate);

        AccountCredit.Reset();
        AccountCredit.SetRange("Member No.", Rec."No.");
        AccountCredit.SetFilter("Date Filter", Dfilter);
        AccountCredit.SetRange("Product Type", 'DP-00103');
        if AccountCredit.FindFirst() then begin
            AccountCredit.CalcFields("Balance (LCY)");
            AmountPost[1] := AccountCredit."Balance (LCY)"
        end;

        AccountCredit.Reset();
        AccountCredit.SetRange("Member No.", Rec."No.");
        AccountCredit.SetFilter("Date Filter", Dfilter);
        AccountCredit.SetRange("Product Type", 'SC-00102');
        if AccountCredit.FindFirst() then begin
            AccountCredit.CalcFields("Balance (LCY)");
            AmountPost[2] := AccountCredit."Balance (LCY)"

        end;

        AccountBanking.Reset();
        AccountBanking.SetRange("Member No.", Rec."No.");
        AccountBanking.SetFilter("Date Filter", Dfilter);
        AccountBanking.SetRange("Product Type", 'IE-00109');
        if AccountBanking.FindFirst() then begin
            AccountBanking.CalcFields("Balance (LCY)");
            AmountPost[3] := AccountBanking."Balance (LCY)";
        end;

        AccountBanking.Reset();
        AccountBanking.SetRange("Member No.", Rec."No.");
        AccountBanking.SetFilter("Date Filter", Dfilter);
        AccountBanking.SetRange("Product Type", 'HD-00108');
        if AccountBanking.FindFirst() then begin
            AccountBanking.CalcFields("Balance (LCY)");
            AmountPost[4] := AccountBanking."Balance (LCY)";
        end;

        AccountBanking.Reset();
        AccountBanking.SetRange("Member No.", Rec."No.");
        AccountBanking.SetFilter("Date Filter", Dfilter);
        AccountBanking.SetRange("Product Type", 'MS-0010');
        if AccountBanking.FindFirst() then begin
            AccountBanking.CalcFields("Balance (LCY)");
            AmountPost[5] := AccountBanking."Balance (LCY)";
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/104');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[1] := (TotalBal[1] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/105');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[2] := (TotalBal[2] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/106');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[3] := (TotalBal[3] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/107');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[4] := (TotalBal[4] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/108');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[5] := (TotalBal[5] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/109');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[6] := (TotalBal[6] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/110');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[7] := (TotalBal[7] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/111');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[8] := (TotalBal[8] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/112');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[9] := (TotalBal[9] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/113');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[10] := (TotalBal[10] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/114');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[11] := (TotalBal[11] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/115');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[12] := (TotalBal[12] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/116');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[13] := (TotalBal[13] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/117');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[14] := (TotalBal[14] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/118');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[15] := (TotalBal[15] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/119');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[16] := (TotalBal[16] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/120');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[17] := (TotalBal[17] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/121');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[18] := (TotalBal[18] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/122');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[19] := (TotalBal[19] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        LoanP.Reset();
        LoanP.SetRange("Account No.", Rec."No.");
        LoanP.SetFilter("Date Filter", Dfilter);
        LoanP.SetRange("Product Type", 'UB/L/123');
        if LoanP.FindSet() then begin
            repeat
                LoanP.CalcFields("Outstanding Balance");
                TotalBal[20] := (TotalBal[20] + LoanP."Outstanding Balance");
            until LoanP.Next() = 0
        end;

        // Shares 
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Rec."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Rec.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Rec."Employer Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AmountPost[2], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AmountPost[1], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AmountPost[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AmountPost[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AmountPost[5], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        ///Loans
        TempExcelBuffer.AddColumn(TotalBal[1], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[2], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[3], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[4], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[5], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[6], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[7], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[8], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[9], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[10], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[11], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[12], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[13], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[14], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[15], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[16], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[17], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[18], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[19], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[20], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[21], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[22], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalBal[23], false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

    end;

    var
        AccountCredit: Record "Account Credit";
        AccountBanking: Record "Account Banking";
        AmountPost: array[15] of Decimal;
        TotalBal: array[27] of Decimal;

}
