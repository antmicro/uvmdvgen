% if license_header:
% for line in license_header:
// ${line.strip()}
% endfor
% endif
{
  name: "${name}"
  // TODO: remove the common testplans if not applicable
  import_testplans: ["hw/dv/tools/dvsim/testplans/csr_testplan.hjson",
                     "hw/dv/tools/dvsim/testplans/mem_testplan.hjson",
                     "hw/dv/tools/dvsim/testplans/intr_test_testplan.hjson",
                     "hw/dv/tools/dvsim/testplans/tl_device_access_types_testplan.hjson"]
  testpoints: [
    {
      name: smoke
      desc: '''
            Smoke test accessing a major datapath within the ${name}.

            **Stimulus**:
            - TBD

            **Checks**:
            - TBD
            '''
      stage: V1
      tests: ["${name}_smoke"]
    }
    {
      name: feature1
      desc: '''Add more test entries here like above.'''
      stage: V1
      tests: []
    }
  ]

  covergroups: [
    {
      name: ${name}_feature_cg
      desc: '''Describe the functionality covered by this covergroup.'''
    }
  ]
}
