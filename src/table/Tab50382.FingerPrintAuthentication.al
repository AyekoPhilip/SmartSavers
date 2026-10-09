table 50382 "FingerPrint Authentication"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Guid"; Guid)
        {
            Caption = 'Guid';
            DataClassification = CustomerContent;
        }
        field(50011; "Authentication Status"; Integer)
        {
            Caption = 'Authentication Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No.", "Guid")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        {
        IF Member.GET("Member No.") THEN
        BEGIN
        IF "Authentication Status" = 1 THEN
         BEGIN
          Member."FingerPrint Verified" := TRUE;
          Member.MODIFY;
         END
        END
        }
        
        //lets use GUID to find and modify transaction
        IF "Authentication Status" = 1 THEN
        BEGIN
          Member.RESET;
          Member.SETRANGE(Member.SystemGeneratedGuid,Guid);
          IF Member.FINDFIRST THEN
          BEGIN
            Member."FingerPrint Verified" := TRUE;
            Member.MODIFY;
          END;
        
          Transactions.RESET;
          Transactions.SETRANGE(Transactions.SystemGeneratedGuid,Guid);
          IF Transactions.FINDFIRST THEN
          BEGIN
            Transactions."FingerPrint Verified" := TRUE;
            Transactions.MODIFY;
          END;
        
          GenJournalBatch.RESET;
          GenJournalBatch.SETRANGE(GenJournalBatch.SystemGeneratedGuid,Guid);
          IF GenJournalBatch.FINDFIRST THEN
          BEGIN
            GenJournalBatch."FingerPrint Verified" := TRUE;
            GenJournalBatch.MODIFY;
          END;
        
        END;
        */

    end;
}




