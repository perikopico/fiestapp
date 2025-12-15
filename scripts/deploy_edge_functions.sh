#!/bin/bash
# Script para desplegar todas las Edge Functions de eliminación de cuentas
# Requiere: Supabase CLI instalado y autenticado

set -e  # Salir si hay error

echo "🚀 Desplegando Edge Functions de eliminación de cuentas..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar que Supabase CLI está instalado
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI no está instalado${NC}"
    echo "Instalando..."
    
    # Intentar instalar en ~/.local/bin
    mkdir -p ~/.local/bin
    curl -fsSL https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | tar -xz -C ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
    
    if ! command -v supabase &> /dev/null; then
        echo -e "${RED}❌ Error al instalar Supabase CLI${NC}"
        echo "Instala manualmente: https://github.com/supabase/cli#install-the-cli"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Supabase CLI encontrado${NC}"
echo ""

# Verificar autenticación
if ! supabase projects list &> /dev/null; then
    echo -e "${YELLOW}⚠️ No estás autenticado en Supabase${NC}"
    echo "Ejecutando: supabase login"
    supabase login
fi

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ No estás en el directorio del proyecto Flutter${NC}"
    exit 1
fi

# Verificar que existe el directorio de funciones
if [ ! -d "supabase/functions" ]; then
    echo -e "${RED}❌ No se encuentra el directorio supabase/functions${NC}"
    exit 1
fi

# Verificar que el proyecto está vinculado
if ! supabase status &> /dev/null; then
    echo -e "${YELLOW}⚠️ El proyecto no está vinculado${NC}"
    read -p "¿Quieres vincular el proyecto ahora? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        read -p "Introduce tu project-ref de Supabase: " PROJECT_REF
        supabase link --project-ref "$PROJECT_REF"
    else
        echo -e "${RED}❌ Necesitas vincular el proyecto primero${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}📦 Desplegando funciones...${NC}"
echo ""

# Función para desplegar
deploy_function() {
    local func_name=$1
    echo -e "${YELLOW}📤 Desplegando ${func_name}...${NC}"
    
    if supabase functions deploy "$func_name" 2>&1; then
        echo -e "${GREEN}✅ ${func_name} desplegada correctamente${NC}"
    else
        echo -e "${RED}❌ Error al desplegar ${func_name}${NC}"
        return 1
    fi
    echo ""
}

# Desplegar todas las funciones
deploy_function "send_deletion_email"
deploy_function "cleanup_deleted_users"
deploy_function "delete_user_account"

echo ""
echo -e "${GREEN}✅ Todas las funciones desplegadas${NC}"
echo ""
echo -e "${YELLOW}⚠️ IMPORTANTE: Configura los secrets en Supabase Dashboard:${NC}"
echo "  1. Ve a Edge Functions → Selecciona cada función → Settings → Secrets"
echo "  2. Añade: SUPABASE_SERVICE_ROLE_KEY"
echo "  3. (Opcional) Añade: RESEND_API_KEY para emails"
echo ""
echo "O ejecuta:"
echo "  supabase secrets set SUPABASE_SERVICE_ROLE_KEY=tu_key"
echo "  supabase secrets set RESEND_API_KEY=tu_key  # Opcional"
echo ""

