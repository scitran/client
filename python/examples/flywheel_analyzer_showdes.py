import scitran_client.flywheel_analyzer as fa

D99 = fa.find(
    fa.request('sessions/588bd1ac449f9800159305c2/acquisitions'),
    label='atlas')


def anatomical_warp_inputs(acquisitions, **kwargs):
    anatomical = fa.find(acquisitions, label='anatomical_mdeft')
    return dict(
        native=anatomical.find_file('*.nii.gz'),
        standard=D99.find_file('D99_template.nii.gz'),
        warp_target=D99.find_file('D99_atlas_1.2a.nii.gz'),
    )

if __name__ == '__main__':
    fa.run([
        fa.define_analysis('afni-brain-warp', anatomical_warp_inputs, label='anatomical warp'),
    ], project=fa.find_project(label='showdes'), max_workers=3)
