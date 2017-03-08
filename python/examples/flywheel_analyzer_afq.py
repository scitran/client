import scitran_client.flywheel_analyzer as fa


def dtiinit_inputs(acquisitions, **kwargs):
    diffusion = fa.find(acquisitions, measurement='diffusion')

    return dict(
        bvec=diffusion.find_file('*.bvec'),
        bval=diffusion.find_file('*.bval'),
        nifti=diffusion.find_file('*.nii.gz'),
    )


def afq_inputs(analyses, **kwargs):
    dtiinit = fa.find(analyses, label='dtiinit')

    return dict(
        dtiInit_Archive=dtiinit.find_file('dtiInit_*.zip'),
    )

if __name__ == '__main__':
    fa.run([
        fa.define_analysis('dtiinit', dtiinit_inputs),
        fa.define_analysis('afq', afq_inputs),
    ], project=fa.find_project(label='ENGAGE'))
