<template>
    <div>
        <el-drawer
            v-model="drawerVisible"
            :destroy-on-close="true"
            :close-on-click-modal="false"
            :close-on-press-escape="false"
            size="30%"
        >
            <template #header>
                <DrawerHeader :header="$t('setting.user')" :back="handleClose"/>
            </template>
            <el-form
                ref="formRef"
                label-position="top"
                :model="form"
                @submit.prevent
                v-loading="loading"
            >
                <el-row type="flex" justify="center">
                    <el-col :span="22">
                        <el-form-item label="Alert Url" prop="alertUrl">
                            <el-input clearable v-model.trim="form.alertUrl"/>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="drawerVisible = false">{{ $t('commons.button.cancel') }}</el-button>
                    <el-button :disabled="loading" type="primary" @click="onSaveUserName(formRef)">
                        {{ $t('commons.button.confirm') }}
                    </el-button>
                </span>
            </template>
        </el-drawer>
    </div>
</template>
<script lang="ts" setup>
import {reactive, ref} from 'vue';
import {MsgSuccess} from '@/utils/message';
import {updateSetting} from '@/api/modules/setting';
import {ElMessageBox, FormInstance} from 'element-plus';
import DrawerHeader from '@/components/drawer-header/index.vue';

interface DialogProps {
    alertUrl: string;
}

const drawerVisible = ref();
const loading = ref();

const form = reactive({
    alertUrl: '',
});
// const rules = reactive({
//     alertUrl: [Rules.alertUrl, Rules.noSpace],
// });
const formRef = ref<FormInstance>();

const acceptParams = (params: DialogProps): void => {
    form.alertUrl = params.alertUrl;
    drawerVisible.value = true;
};
const emit = defineEmits<{ (e: 'search'): void }>();

const onSaveUserName = async (formEl: FormInstance | undefined) => {
    if (!formEl) return;
    formEl.validate(async (valid) => {
        if (!valid) return;
        // ElMessageBox.confirm(i18n.global.t('setting.userChangeHelper'), i18n.global.t('setting.userChange'), {
        //     confirmButtonText: i18n.global.t('commons.button.confirm'),
        //     cancelButtonText: i18n.global.t('commons.button.cancel'),
        //     type: 'info',
        // }).then(async () => {
        await updateSetting({key: 'AlertUrl', value: form.alertUrl})
            .then(async () => {
                // await logOutApi();
                MsgSuccess("save success");
                loading.value = false;
                drawerVisible.value = false;
                emit('search');
                return;
            })
            .catch(() => {
                loading.value = false;
            });
        // });
    });
};

const handleClose = () => {
    drawerVisible.value = false;
};

defineExpose({
    acceptParams,
});
</script>
