pageextension 61131 "PTE PdfReprocess Doc List Ext" extends "CDC Document List With Image"
{
    actions
    {
        addafter("Incoming E-Mail")
        {
            action(SearchByLinkedField)
            {
                ApplicationArea = All;
                Caption = 'Reprocess broken pdf file';
                Description = 'Click here to send the pdf file for reprocessing.';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'The file will be send to a webservice that converts the pdf into tiff format, converts it back to pdf and sends it again to the Cloud OCR mail address of this document category.';

                trigger OnAction()
                var
                    ReprocessMgt: Codeunit "PTE PdfReprocess Mgt.";
                begin
                    ReprocessMgt.ReprocessDocument(Rec);
                end;
            }
        }
    }
}
