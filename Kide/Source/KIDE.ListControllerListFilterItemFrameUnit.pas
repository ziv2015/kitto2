{-------------------------------------------------------------------------------
   Copyright 2012-2018 Ethea S.r.l.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-------------------------------------------------------------------------------}
unit KIDE.ListControllerListFilterItemFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ExtCtrls, EF.Tree, Vcl.StdCtrls,
  KIDE.EditNodeBaseFrameUnit,
  SynEdit, SynHighlighterSQL;

type
  TListControllerListFilterItemFrame = class(TEditNodeBaseFrame)
    LabelEdit: TLabeledEdit;
    _IsDefault: TCheckBox;
    ExpressionPanel: TPanel;
    ExpressionLabel: TLabel;
  private
    FSynSQLSyn: TSynSQLSyn;
    FExpressionEdit: TSynEdit;
  protected
    class function SuitsNode(const ANode: TEFNode): Boolean; override;
    procedure CleanupDefaultsToEditNode; override;
    procedure DesignPanelToEditNode; override;
  public
    procedure UpdateDesignPanel(const AForce: Boolean = False); override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}
uses
  KIDE.Utils,
  Kitto.Ext.Filters,
  KIDE.ListControllerListFilterNodeFrameUnit;

{ TListControllerListFilterItemFrame }

procedure TListControllerListFilterItemFrame.CleanupDefaultsToEditNode;
begin
  inherited;
  CleanupBooleanNode('IsDefault');
  CleanupTextNode('Expression');
end;

constructor TListControllerListFilterItemFrame.Create(AOwner: TComponent);
begin
  inherited;
  FSynSQLSyn := TSynSQLSyn.Create(Self);
  FExpressionEdit := CreateSynEditor(Self, ExpressionPanel,
    '_Expression', FSynSQLSyn, Font.Size, EditorChange);
end;

procedure TListControllerListFilterItemFrame.DesignPanelToEditNode;
begin
  inherited;
  TEFNode(EditNode).AsString := LabelEdit.Text;
end;

class function TListControllerListFilterItemFrame.SuitsNode(const ANode: TEFNode): Boolean;
begin
  Result := (ANode.Parent is TEFNode) and
    SameText(TEFNode(ANode.Parent).Name, 'Items') and
    (TEFNode(ANode.Parent).Parent is TEFNode) and
    TListControllerListFilterNodeFrame.IsListControllerListFilterNode(TEFNode(TEFNode((ANode.Parent)).Parent));
end;

procedure TListControllerListFilterItemFrame.UpdateDesignPanel(const AForce: Boolean);
begin
  _IsDefault.Checked := False;
  LabelEdit.Text := '';
  inherited;
  LabelEdit.Text := TEFNode(EditNode).AsString;
end;

initialization
  TEditNodeFrameRegistry.Instance.RegisterClass(TListControllerListFilterItemFrame.GetClassId, TListControllerListFilterItemFrame);

finalization
  TEditNodeFrameRegistry.Instance.UnregisterClass(TListControllerListFilterItemFrame.GetClassId);

end.