unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CommCtrl;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure AdjustProgressBar(item: TListItem; r: TRect);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 i: Byte;
 r: TRect;
 pb: TProgressBar;
begin
 Listview1.Columns.Add.Width:=100;
 Listview1.Columns.Items[0].Caption:='Text';
 Listview1.Columns.Add.Width:=400;
 Listview1.Columns.Items[1].Caption:='Progress';
 Listview1.ViewStyle:=vsReport;

 Randomize;
 for i:=0 to 40 do
  begin
   Listview1.Items.Add.Caption:='Some text '+IntToStr(i+1);
   // On récupère le rectangle d'affichage de l'élément
   // Il sera utilisé pour mettre la progressbar à la bonne taille
   r:=Listview1.Items[i].DisplayRect(drBounds);
   // Création et initialisation de la progressbar
   pb:=TProgressBar.Create(Self);
   pb.Parent:=Listview1;
   // Ici, c'est juste pour avoir des positions différentes
   pb.Position:=Random(pb.Max);
   pb.Smooth:=true;
   // On stoque la progressbar dans la propriété Data de l'élément
   // afin de pouvoir la récupérer plus tard
   Listview1.Items[i].Data:=pb;
   AdjustProgressBar(Listview1.Items[i], r);
  end;
end;

procedure TForm1.AdjustProgressBar(item: TListItem; r: TRect);
var
 pb: TProgressBar;
begin
 // Procédure qui met à jour la taille de la ProgressBar en fonction du rectangle d'affichage de l'élément
 // qui contient la ProgressBar et en fonction de la taille de la colonne
 // dans laquelle on met la progressbar (ici, la 2ème colonne)
 r.Left:=r.Left+Listview1.columns[0].Width;
 r.Right:=r.Left+Listview1.columns[1].Width;
 pb:=item.Data;
 pb.BoundsRect:=r;
end;

procedure TForm1.WMNotify(var Message: TWMNotify);
var
 r: TRect;
 i: integer;
begin
 // Procédure qui capture le message de "colonne resize"
 // afin d'adapter la taille de toutes les progressbar de la listview
 case Message.NMHdr.code of
    HDN_ITEMCHANGED, HDN_ITEMCHANGING:
     // Pour plus d'infos sur les différents messages des headers pour les listview, ce rapporter ici : (en anglais)
     // http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/header/notifications/hdn_itemchanged.asp
     begin
      for i:=0 to Listview1.Items.Count-1 do
       begin
        r:=Listview1.Items[i].DisplayRect(drBounds);
        AdjustProgressBar(Listview1.Items[i], r);
       end;
      // On force le repaint de la listview pour éviter un bug d'affichage : il affichait des progressbar dans le header de la colonne.
      // L'inconvénient est que le repaint clignote un peu dans ce cas. :(
      ListView1.Repaint;
     end;
 end;

 inherited;
end;

procedure TForm1.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 r: TRect;
begin
 r:=Item.DisplayRect(drBounds);
 // On teste si le rectangle de l'élément se trouve en dessous du header des colonnes.
 // Sinon, il affiche les progressbar sur les colonnes
 if r.Top>=Listview1.BoundsRect.Top
 then AdjustProgressBar(Item, r);
end;

end.
