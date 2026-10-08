codeunit 50067 "Post Alt. Channel ( Yes/No )"
{
    trigger OnRun()
    begin

    end;

    var

        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        TransT: Record "ATM Transaction";
        AccountTypes: Record "Product Factory";
        GenJournalLine: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
        MTrans: Record "Mobile Loan Transaction";
        Loans: record Loans;
        NotifSource: Enum NotifSourceType;
        Member: Record Member;
        Comp: Record "Company Information";
        Gensetup: Record "General Set-Up";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        RegMngt: Codeunit "Register Management";
        Source: Enum NotifSourceType;
        Docs: Codeunit "SMS Notification";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PostAs: Option "Post Amount","Post Less Charges";
        TransCharges: Record "Transaction Charge";
        AltChannelMngt: Codeunit "Alt. Channel (Mobile Mngt.)";






}



