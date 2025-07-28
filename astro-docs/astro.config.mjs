// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'My Docs',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/withastro/starlight' }],
			sidebar: [
				{
					label: 'Docs',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'General', slug: 'infra/general' },
						{ label: 'Kubernetes', slug: 'infra/kubernetes' },
						{ label: 'GitHub Actions', slug: 'infra/github_actions' },
						{ label: 'Terraform Import', slug: 'infra/terraform-import' },
					],
				},
				{
					label: 'Reference',
					autogenerate: { directory: 'reference' },
				},
			],
		}),
	],
});
