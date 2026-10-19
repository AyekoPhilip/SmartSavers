codeunit 50002 "Receipts and Payments-Post"
{
    // Meant for Posting of HELB Balances
    trigger OnRun()
    begin
    end;

    procedure PostReceipt()
    begin
        /*
        if Confirm('Are you sure you want to post the HELB Receipt Batch no '+HelbHeader.Code+' ?')=true then begin
          if HelbHeader.Posted then
             Error('The HELB Batch has been posted');
            HelbHeader.TestField(Date);
            HelbHeader.TestField(Description);
          GenSetup.Get();
          GenSetup.TestField("HELB Control Account");
          // Delete Lines Present on the General Journal Line
          GenJnLine.Reset();
          GenJnLine.SetRange(GenJnLine."Journal Template Name",GenSetup."Receipt Template");
          GenJnLine.SetRange(GenJnLine."Journal Batch Name",HelbHeader.Code);
          GenJnLine.DeleteAll();
          Batch.Init();
          if GenSetup.Get() then
          Batch."Journal Template Name":=GenSetup."Receipt Template";
          Batch.Name:=HelbHeader.Code;
          if not Batch.Get(Batch."Journal Template Name",Batch.Name) then
          Batch.Insert();
          //Post control account entries
          HelbHeader.CalcFields(HelbHeader."Total Amount");
          LineNo:=LineNo+1000;
          GenJnLine.Init();
          GenJnLine."Journal Template Name":=GenSetup."Receipt Template";
          GenJnLine."Journal Batch Name":=HelbHeader.Code;
          GenJnLine."Line No.":=LineNo;
          GenJnLine."Account Type":=GenJnLine."Account Type"::Customer;
          GenJnLine."Account No.":=GenSetup."HELB Control Account";
          GenJnLine."Posting Date":=HelbHeader.Date;
          GenJnLine."Document No.":=HelbHeader.Code;
          GenJnLine.Description:=HelbHeader.Description;
          GenJnLine.Amount:=HelbHeader."Total Amount";
          GenJnLine.Validate(GenJnLine.Amount);
          GenJnLine."External Document No.":=HelbHeader.Code;
          GenJnLine."Shortcut Dimension 1 Code":=HelbHeader."Global Dimension 1 Code";
          GenJnLine.Validate(GenJnLine."Shortcut Dimension 1 Code");
          GenJnLine."Shortcut Dimension 2 Code":=HelbHeader."Global Dimension 2 Code";
          GenJnLine.Validate(GenJnLine."Shortcut Dimension 2 Code");
          GenJnLine."Department Code":=HelbLine."Department Code";
          GenJnLine.Validate(GenJnLine."Department Code");
          if GenJnLine.Amount<>0 then
             GenJnLine.Insert();
         //Post the receipt lines
          HelbLine.SetRange(HelbLine.Code,HelbHeader.Code);
          if HelbLine.FindFirst() then begin
             repeat
             HelbLine.Validate(Amount);
             LineNo:=LineNo+1000;
             GenJnLine.Init();
             GenJnLine."Journal Template Name":=GenSetup."Receipt Template";
             GenJnLine."Journal Batch Name":=HelbHeader.Code;
             GenJnLine."Line No.":=LineNo;
             GenJnLine."Account Type":=GenJnLine."Account Type"::Customer;
             GenJnLine."Account No.":=HelbLine."Account No";
             GenJnLine.Validate(GenJnLine."Account No.");
             GenJnLine."Posting Date":=HelbHeader.Date;
             GenJnLine."Document No.":=HelbHeader.Code;
             GenJnLine.Description:=HelbLine."Candidate Name"+'-'+'Batch No -'+HelbHeader.Code;
             GenJnLine.Amount:=-HelbLine.Amount;
             GenJnLine.Validate(GenJnLine.Amount);
             GenJnLine."External Document No.":=HelbHeader.Code;
             GenJnLine.Validate(GenJnLine."Currency Code");
             GenJnLine."Shortcut Dimension 1 Code":=HelbLine."Global Dimension 1 Code";
             GenJnLine.Validate(GenJnLine."Shortcut Dimension 1 Code");
             GenJnLine."Shortcut Dimension 2 Code":=HelbLine."Global Dimension 2 Code";
             GenJnLine.Validate(GenJnLine."Shortcut Dimension 2 Code");
             GenJnLine."Department Code":=HelbLine."Department Code";
             GenJnLine.Validate(GenJnLine."Department Code");
             if GenJnLine.Amount<>0 then
                GenJnLine.Insert();
             until
              HelbLine.Next()=0;
            end;
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnLine);
            GLEntry.Reset();
            GLEntry.SetRange(GLEntry."Document No.",HelbHeader.Code);
            GLEntry.SetRange(GLEntry.Reversed,false);
            if GLEntry.FindFirst() then begin
            HelbHeader.Posted:=true;
            HelbHeader."Posted Date":=Today;
            HelbHeader."Posted Time":=Time;
            HelbHeader."Posted By":=UserId;
            HelbHeader.Modify();
            end;
        end;
        */

    end;
}


