module ReportsHelper
  def report_parameters
    [
        {name: 'Business Prospects', field: 'status'}, # Business Prospect is the combination of all Project states
        {name: 'Prospects by Type', field: 'project_type'},
        {name: 'Industry Type', field: 'industry_type'},
        {name: 'Prospect Lead Sources', field: 'source'},
        {name: 'Reasons or Project Elimination', field: 'elimination_reason'},
        {name: 'Competition', field: 'elimination_reason'},
        {name: 'Prospect Acreage Request', field: 'acres_requested'},
        {name: 'Prospect Square foot Request', field: 'square_feet_requested'},
        {name: 'Total Number of New Jobs/Total New Investment', field: 'net_new_investment'},
        {name: 'Prospects by Type (year to year comparison)', field: 'project_type'},
        {name: 'Industry Type (year to year comparison)', field: 'industry_type'},
        {name: 'Prospect Lead Sources (year to year comparison)', field: 'source'},
        {name: 'Reasons or Project Elimination (year to year comparison)', field: 'elimination_reason'}
    ]
  end
end
