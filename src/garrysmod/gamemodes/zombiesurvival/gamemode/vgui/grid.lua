local PANEL = {}

AccessorFunc(PANEL, "horizontalMargin", "HorizontalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "verticalMargin", "VerticalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "rowHeight", "RowHeight", FORCE_NUMBER)

function PANEL:Init()
    self.cells = {}

    self:SetPaintBackground(false)

    self:Dock(TOP)
end

function PANEL:SetVerticalMargin(verticalMargin)
    self.verticalMargin = verticalMargin
    self:DockMargin(0, verticalMargin / 2, 0, verticalMargin / 2)
end

function PANEL:AddCell(cell)
    table.insert(self.cells, cell)

    cell:SetParent(self)

    cell:Dock(LEFT)

    cell.PerformLayout = function(self, _, _)
        local parent = self:GetParent()

        self:DockMargin(parent:GetHorizontalMargin() / 2, 0, parent:GetHorizontalMargin() / 2, 0)
        -- (194 / 4 - 8) = 40.5, so there is a chance that this will result in a
        -- floating point value that gets converted to an integer when running
        -- SetWide(), causing things to be skewed by a pixel or 2.
        -- parent:GetWide() % #parent.cells would get that remainder if you
        -- wanted to do correction.
        self:SetWide(parent:GetWide() / #parent.cells - parent:GetHorizontalMargin())
    end

    self:SetTall(self:CalculateHeight())

    self:InvalidateLayout(true)
end

function PANEL:CalculateHeight()
    if self.rowHeight then return self.rowHeight end

    local height = 0

    for _,v in ipairs(self.cells) do
       height = math.max(height, v:GetTall())
    end

    return height
end

function PANEL:PerformLayout()
    for _,v in ipairs(self.cells) do
       v:InvalidateChildren(true)
    end

    self:SetTall(self:CalculateHeight())
end

PANEL.AllowAutoRefresh = true

derma.DefineControl("ZSRow", "", PANEL, "DPanel")

local PANEL = {}

AccessorFunc(PANEL, "horizontalMargin", "HorizontalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "verticalMargin", "VerticalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "columns", "Columns", FORCE_NUMBER)
AccessorFunc(PANEL, "rowHeight", "RowHeight", FORCE_NUMBER)

function PANEL:Init()
    self.rows = {}
    self.cells = {}

    self:SetPaintBackground(false)

    self.backgroundColor = table.Random({Color(255, 0, 0), Color(0, 255, 0)})

    self:Dock(TOP)
end

function PANEL:SetVerticalMargin(verticalMargin)
    self.verticalMargin = verticalMargin
    local left, _, right = self:GetDockPadding()
    self:DockPadding(left, verticalMargin / 2, right, verticalMargin / 2)
end

function PANEL:SetHorizontalMargin(horizontalMargin)
    self.horizontalMargin = horizontalMargin
    local _, top, _, bottom = self:GetDockPadding()
    self:DockPadding(horizontalMargin / 2, top, horizontalMargin / 2, bottom)
end

function PANEL:SetRowHeight(rowHeight)
    self.rowHeight = rowHeight

    for _,v in ipairs(self.rows) do
        v:SetRowHeight(rowHeight)
    end
end

function PANEL:AddCell(cell)
    local cols = self:GetColumns()
    local idx = math.floor(#self.cells / cols) + 1
    self.rows[idx] = self.rows[idx] or self:CreateRow()

    self.rows[idx]:AddCell(cell)

    table.insert(self.cells, cell)
end

function PANEL:CreateRow()
    local row = vgui.Create("ZSRow", self)
    row:SetVerticalMargin(self:GetVerticalMargin())
    row:SetHorizontalMargin(self:GetHorizontalMargin())
    row:SetRowHeight(self:GetRowHeight())
    return row
end

function PANEL:CalculateHeight()
    local height = 0

    for _,v in ipairs(self.rows) do
       height = height + v:GetTall() + self:GetVerticalMargin() * 1.5
    end

    return height
end

function PANEL:PerformLayout()
    for _,v in ipairs(self.rows) do
       v:InvalidateChildren(true)
    end

    self:SetTall(self:CalculateHeight())
end

PANEL.AllowAutoRefresh = true

derma.DefineControl("ZSGrid", "", PANEL, "DPanel")
