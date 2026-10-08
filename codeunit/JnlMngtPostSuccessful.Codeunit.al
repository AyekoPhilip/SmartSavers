codeunit 50013 "Jnl Mngt. Post Successful"
{
    trigger OnRun()
    begin
    end;

    procedure PostedSuccessfully() Posted: Boolean
    // ValPost: Record "Value Posting";
    begin
        Posted := false;
        // ValPost.SetRange(ValPost.UserID, UserId);
        //ValPost.SetRange(ValPost."Value Posting", 1);
        // if ValPost.Find('-') then
        Posted := true;
    end;
}


