unit HeaderFooterTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation,


  {$IFDEF ANDROID}


 Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Comp.Client, FireDAC.Phys.SQLiteVDataSet, System.IOUtils;




   {$ENDIF}

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

{$R *.fmx}

procedure THeaderFooterForm.Button1Click(Sender: TObject);
var telefone : string;
URL: string;

 Intent: JIntent;
texto: string;

 Dados: TBinaryWriter;
Begin

telefone:= Edit1.Text;

telefone:= StringReplace(telefone, '-', '',
   [rfReplaceAll, rfIgnoreCase]);

   telefone:= StringReplace(telefone, ' ', '',
   [rfReplaceAll, rfIgnoreCase]);

   telefone:= copy(telefone, (Length(telefone) - 10) ,  Length(telefone));

 texto:= Memo1.Lines.Text;


  URL := 'whatsapp://send?phone=55'+telefone+'&text='+texto;
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
      TJnet_Uri.JavaClass.parse(StringToJString(URL)));
  SharedActivity.startActivity(Intent);

  SaveState.Stream.Clear;
  Dados := TBinaryWriter.Create(SaveState.Stream);
  try
    Dados.Write(Memo1.Lines.Text);
  finally
    Dados.Free;
end;
end;


procedure THeaderFooterForm.FormCreate(Sender: TObject);
begin
var
  DadosSalvos: TBinaryReader;
begin
SaveState.StoragePath := TPath.GetHomePath;
  if SaveState.Stream.Size > 0 then begin
    DadosSalvos := TBinaryReader.Create(SaveState.Stream);
    try
      Memo1.Lines.Text := DadosSalvos.ReadString;
    finally
      DadosSalvos.Free;
    end;
  end;
  end;
end;




end.
